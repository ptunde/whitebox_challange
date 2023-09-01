//
//  ContentViewModel.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 29..
//

import Foundation
import Combine
import SwiftUI



// MARK: - class
class ContentViewModel: ObservableObject {
    
    // MARK: - published props
    @Published var state: State = .loading
    @Published var searchQuerry = ""
    @Published var isDisplayingOnlyFavorites = false
    
    
    // MARK: - private props
    @Published private var allData = [CryptoAsset]()
    private var repository: CryptoRepository!
    private var cancellables = Set<AnyCancellable>()
    private var workScheduler: DispatchQueue!
    private var mainScheduler: DispatchQueue!
    
    
    
    // MARK: - helper
    enum State {
        case loading, loaded(list: [CryptoAsset], isOfflineData: Bool), error(String)
    }
    
    
    
    // MARK: - init
    init(repository: CryptoRepository = CryptoRepositoryImpl(remoteDatasource: CryptoRemoteDatasourceImpl(configuration: CryptoRemoteDatasourceConfiguration()),
                                                             localDatasource: CryptoLocalDatasourceImpl()),
         workScheduler: DispatchQueue = DispatchQueue.global(),
         mainScheduler: DispatchQueue = DispatchQueue.main) {
        
        self.repository = repository
        self.workScheduler = workScheduler
        self.mainScheduler = mainScheduler
        
        self.loadCryptoList()
    }
    
    
    
    func reloadData() {
        cancellables.removeAll(keepingCapacity: true)
        self.loadCryptoList()
    }
    
    
    
    func onTapIsFavorite(asset: CryptoAsset) {
        if case .loaded(_, _) = state {
            repository
                .updateAsset(asset: asset.copy(isFavorite: !asset.isFavorite))
                .subscribe(on: workScheduler)
                .receive(on: mainScheduler)
                .sink { compl in
                    // no-op
                } receiveValue: { [weak self] value in
                    guard let weakself = self else { return }
                    if let index = weakself.allData.firstIndex(where: { $0.id == asset.id }) {
                        weakself.allData[index].isFavorite = value.isFavorite
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    
    
    func onTapToggleFavorites() {
        isDisplayingOnlyFavorites = !isDisplayingOnlyFavorites
    }
    
    
    
    // MARK: - helper
    private func loadCryptoList() {
        updateState(.loading)
        
        repository
            .getAssetList()
            .subscribe(on: workScheduler)
            .receive(on: mainScheduler)
            .sink { [weak self] compl in
                if case .failure = compl {
                    self?.updateState(.error("unable_to_load_data".localized()))
                }
            } receiveValue: { [weak self] value in
                self?.subscribeToFilters(isOfflineData: value.isOfflineData)
                self?.allData = value.list
            }
            .store(in: &cancellables)
    }
    
    
    
    private func subscribeToFilters(isOfflineData: Bool) {
        Publishers
            .CombineLatest3(
                $allData,
                $isDisplayingOnlyFavorites,
                $searchQuerry
                    .debounce(for: .seconds(0.5), scheduler: workScheduler)
                    .removeDuplicates())
            
            .map { data, favs, query in
                self.updateList(data: data, showFavorites: favs, searchQuery: query)
            }
            .subscribe(on: workScheduler)
            .receive(on: mainScheduler)
            .sink { [weak self] list in
                self?.updateState(.loaded(list: list, isOfflineData: isOfflineData))
            }
            .store(in: &cancellables)
        
    }
    
    
    
    private func updateList(data: [CryptoAsset], showFavorites: Bool, searchQuery: String) -> [CryptoAsset] {
        
        let filterByFav: [CryptoAsset]
        
        switch showFavorites {
        case true:
            filterByFav = data.filter { $0.isFavorite == true }
        case false:
            filterByFav = data
        }
        
        switch searchQuery.isEmpty {
        case true:
            return filterByFav
        case false:
            return filterByFav.filter {
                $0.id.lowercased().contains(searchQuerry.lowercased()) ||
                $0.name.lowercased().contains(searchQuerry.lowercased())
            }
        }
        
    }
    
    
    
    private func updateState(_ state: State) {
        withAnimation { self.state = state }
    }
}
