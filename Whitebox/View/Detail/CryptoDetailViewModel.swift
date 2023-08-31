//
//  CryptoDetailViewModel.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Foundation
import Combine
import SwiftUI



// MARK: - class
class CryptoDetailViewModel: ObservableObject {
    
    // MARK: - published props
    @Published var state: State = .loading
    
    
    
    // MARK: - private props
    private var repository: CryptoRepository!
    private var cancellables = Set<AnyCancellable>()
    private var workScheduler: DispatchQueue!
    private var mainScheduler: DispatchQueue!
    
    
    
    // MARK: - helper
    enum State {
        case loading, loaded(CryptoDetailVO), error(String)
    }
    
    
    
    // MARK: - init
    init(asset: CryptoAsset,
         repository: CryptoRepository = CryptoRepositoryImpl(remoteDatasource: CryptoRemoteDatasourceImpl(configuration: CryptoRemoteDatasourceConfiguration()),
                                                             localDatasource: CryptoLocalDatasourceImpl()),
         workScheduler: DispatchQueue = DispatchQueue.global(),
         mainScheduler: DispatchQueue = DispatchQueue.main) {
        
        self.repository = repository
        self.workScheduler = workScheduler
        self.mainScheduler = mainScheduler
        
        loadExchangeRate(for: asset)
    }
    
    
    
    // MARK: - helper
    private func loadExchangeRate(for asset: CryptoAsset) {
        updateState(.loading)
        
        repository
            .getAssetExchangeRate(id: asset.id, inCurrency: .euro)
            .subscribe(on: workScheduler)
            .receive(on: mainScheduler)
            .sink { [weak self] compl in
                if case .failure = compl {
                    self?.updateState(.error("Unable to load data. Please try again later"))
                }
            } receiveValue: { [weak self] value in
                let data = CryptoDetailVO(name: asset.name,
                                          detail: "Detail of \(asset.name)",
                                          rate: "Exchange rate: \(String(format: "%.1f", value.rate)) euro")
                self?.updateState(.loaded(data))
            }
            .store(in: &cancellables)
    }
    
    
    
    private func updateState(_ state: State) {
        withAnimation { self.state = state }
    }
}
