//
//  WhiteboxTests.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import XCTest
@testable import Whitebox
import Combine



final class CryptoDetailViewModelTests: XCTestCase {

    // MARK: - Properties
    private var sut: CryptoDetailViewModel!
    private var repo: MockCryptoRepository!
    private var asset: CryptoAsset!
    private var expectation: XCTestExpectation!
    
    
    
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        asset = CryptoAsset(id: "btc", name: "Bitcoin", icon: nil, isFavorite: false)
        repo = MockCryptoRepository()
    }
    
    
    
    override func tearDown() {
        sut = nil
        asset = nil
        repo = nil
        expectation = nil
        super.tearDown()
    }
    
    
    
    // MARK: - tests - init
    func test_init_onInitExchangeRateIsFetched() {
        // given
        givenRepo()
        
        // when
        
        // then
        XCTAssertTrue(repo.getRateCalls.filter { $0 == asset.id }.count > 0, "Exchange rate not requested")
    }
    
    
    
    // MARK: - tests - state
    func test_state_whenFetchingExchangeRate_stateIsLoading() {
        // given
        givenRepo()
        
        // when
        
        // then
        XCTAssertEqual(sut.state, .loading, "Incorrect state while loading exchange rate")
    }
    
    
    
    func test_state_whenFetchingExchangeRateSuccess_stateIsIdle() {
        // given
        givenRepo(repoResult: .success(CryptoExchangeRate(id: "Btc", rate: 2.5)))
        expectation = expectation(description: "waiting for state")
        let stateTester = FlowableTester(flowable: sut.$state.eraseToAnyPublisher())
        
        // when
        stateTester.onUpdate = { value, index in
            if index == 1 {
                self.expectation.fulfill()
            }
        }
        
        // then
        onExpectationFulfilled {
            switch stateTester.value(at: 1) {
            case .loaded(let data): XCTAssertTrue(data.name == "Bitcoin", "Incorrect state after exchange rate is loaded")
            default: assertionFailure("this should never happen")
            }
        }
    }
    
    
    
    func test_state_whenFetchingExchangeRateFails_stateIsError() {
        // given
        givenRepo(repoResult: .failure(CustomError.api(error: .assetNotFound)))
        expectation = expectation(description: "waiting for state")
        let stateTester = FlowableTester(flowable: sut.$state.eraseToAnyPublisher())
        
        // when
        stateTester.onUpdate = { value, index in
            if index == 1 {
                self.expectation.fulfill()
            }
        }
        
        // then
        onExpectationFulfilled {
            switch stateTester.value(at: 1) {
            case .error: XCTAssertTrue(true, "Incorrect state after exchange rate failed to load")
            default: XCTAssertFalse(true, "Incorrect state after exchange rate failed to load")
            }
        }
    }

    
    
    // MARK: - helpers
    private func givenRepo(repoResult: ResponseResult<CryptoExchangeRate> = .failure(CustomError.api(error: .assetNotFound))) {
        repo.getRateResult = Deferred {
            Future { promise in
                switch repoResult {
                case .success(let data): promise(.success(data))
                case .failure(let err): promise(.failure(err))
                }
            }
        }
        sut = CryptoDetailViewModel(asset: asset, repository: repo)
    }
    
    
    
    private func onExpectationFulfilled(callback: () -> Void) {
        wait(for: [expectation], timeout: 1)
        callback()
    }
}
