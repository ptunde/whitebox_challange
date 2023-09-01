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
                guard let weakself = self else { return }
                let data = weakself.getValueObject(from: asset, rate: value)
                weakself.updateState(.loaded(data))
            }
            .store(in: &cancellables)
    }
    
    
    
    private func updateState(_ state: State) {
        withAnimation { self.state = state }
    }
    
    
    
    private func getValueObject(from asset: CryptoAsset, rate: CryptoExchangeRate) -> CryptoDetailVO {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        
        let rate = formatter.string(from: rate.rate as NSNumber) ?? "\(rate.rate)"
        
        return CryptoDetailVO(name: asset.name,
                              detail: "Name: \(asset.name)\nCode: \(asset.id)",
                              rate: "Exchange rate\n\(rate) €")
    }
}
