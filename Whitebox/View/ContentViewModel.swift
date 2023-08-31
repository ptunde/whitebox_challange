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
    
    
    
    // MARK: - private props
    private var repository: CryptoRepository!
    private var cancellables = Set<AnyCancellable>()
    private var workScheduler: DispatchQueue!
    private var mainScheduler: DispatchQueue!
    
    
    
    // MARK: - helper
    enum State {
        case loading, loaded([CryptoAsset]), error(String)
    }
    
    
    
    // MARK: - init
    init(repository: CryptoRepository = CryptoRepositoryImpl(remoteDatasource: CryptoRemoteDatasourceImpl(configuration: CryptoRemoteDatasourceConfiguration())),
         workScheduler: DispatchQueue = DispatchQueue.global(),
         mainScheduler: DispatchQueue = DispatchQueue.main) {
        
        self.repository = repository
        self.workScheduler = workScheduler
        self.mainScheduler = mainScheduler
        
        self.loadCryptoList()
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
                self?.updateState(.loaded(value))
            }
            .store(in: &cancellables)
    }
    
    
    
    private func updateState(_ state: State) {
        withAnimation { self.state = state }
    }
}
