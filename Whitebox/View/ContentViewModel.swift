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
    private var allData = [CryptoAsset]()
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
    
    
    
    func onTapIsFavorite(asset: CryptoAsset) {
        if case .loaded(_, let isOfflineData) = state {
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
                    weakself.updateState(.loaded(list: weakself.allData, isOfflineData: isOfflineData))
                }
                .store(in: &cancellables)
        }
    }
    
    
    
    func onTapToggleFavorites() {
        if case .loaded(_, let isOfflineData) = state {
            
            isDisplayingOnlyFavorites = !isDisplayingOnlyFavorites
            
            switch isDisplayingOnlyFavorites {
            case true:
                let custom = allData.filter { $0.isFavorite == true }
                updateState(.loaded(list: custom, isOfflineData: isOfflineData))
            case false:
                updateState(.loaded(list: allData, isOfflineData: isOfflineData))
            }
        }
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
                    self?.updateState(.error("Unable to load data. Please try again later"))
                }
            } receiveValue: { [weak self] value in
                self?.allData = value.list
                self?.updateState(.loaded(list: value.list, isOfflineData: value.isOfflineData))
                self?.subscribeToSearchText()
            }
            .store(in: &cancellables)
    }
    
    
    
    private func subscribeToSearchText() {
        if case .loaded(_, let isOfflineData) = state {
            
            $searchQuerry
                .dropFirst(1)
                .debounce(for: .seconds(0.5), scheduler: mainScheduler)
                .removeDuplicates()
                .subscribe(on: workScheduler)
                .receive(on: mainScheduler)
                .sink { value in
                    switch value.isEmpty {
                    case true: self.updateState(.loaded(list: self.allData, isOfflineData: isOfflineData))
                    case false:
                        let filtered = self.allData.filter {
                            $0.id.lowercased().contains(value.lowercased()) || $0.name.lowercased().contains(value.lowercased())
                        }
                        
                        self.updateState(.loaded(list: filtered, isOfflineData: isOfflineData))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    
    
    private func updateState(_ state: State) {
        withAnimation { self.state = state }
    }
}
