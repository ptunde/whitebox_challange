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
        case loading, loaded([CryptoAsset]), error(String)
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
        
        var item = asset.copy()
        item.isFavorite = !asset.isFavorite
        
        repository
            .updateAsset(asset: item)
            .subscribe(on: workScheduler)
            .receive(on: mainScheduler)
            .sink { compl in
                // no-op
            } receiveValue: { [weak self] value in
                guard let weakself = self else { return }
                if let index = weakself.allData.firstIndex(where: { $0.id == asset.id }) {
                    weakself.allData[index].isFavorite = value.isFavorite
                }
                weakself.updateState(.loaded(weakself.allData))
            }
            .store(in: &cancellables)
    }
    
    
    
    func onTapToggleFavorites() {
        isDisplayingOnlyFavorites = !isDisplayingOnlyFavorites
        
        switch isDisplayingOnlyFavorites {
        case true:
            let custom = allData.filter { $0.isFavorite == true }
            updateState(.loaded(custom))
        case false:
            updateState(.loaded(allData))
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
                self?.allData = value
                self?.updateState(.loaded(value))
                self?.subscribeToSearchText()
            }
            .store(in: &cancellables)
    }
    
    
    
    private func subscribeToSearchText() {
        if case .loaded = state {
            
            $searchQuerry
                .dropFirst(1)
                .debounce(for: .seconds(0.5), scheduler: mainScheduler)
                .subscribe(on: workScheduler)
                .receive(on: mainScheduler)
                .sink { value in
                    switch value {
                    case "": self.updateState(.loaded(self.allData))
                    default: self.updateState(.loaded(self.allData.filter { $0.id.lowercased().contains(value.lowercased()) }))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    
    
    private func updateState(_ state: State) {
        withAnimation { self.state = state }
    }
}
