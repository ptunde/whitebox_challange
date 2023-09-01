//
//  CryptoRepositoryTests.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import XCTest
@testable import Whitebox
import Combine


/// tests only getting crypto asset Rate
final class CryptoRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: CryptoRepository!
    private var rate: CryptoExchangeRate!
    private var local: MockCryptoLocalDatasource!
    private var remote: MockCryptoRemoteDatasource!
    private var expectation: XCTestExpectation!
    private var cancellables = Set<AnyCancellable>()
    private var errorResult: Error?
    
    
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        rate = CryptoExchangeRate(id: "BTC", rate: 26000)
        local = MockCryptoLocalDatasource()
        remote = MockCryptoRemoteDatasource()
        sut = CryptoRepositoryImpl(remoteDatasource: remote, localDatasource: local)
    }
    
    
    
    override func tearDown() {
        sut = nil
        rate = nil
        local = nil
        remote = nil
        expectation = nil
        cancellables.forEach { $0.cancel() }
        super.tearDown()
    }
    
    
    
    // MARK: - tests - init
    func test_getRate_whenRemoteAndLocalSucceeds_noErrorIsReturned() {
        // given
        givenRemoteGetRateResult(result: .success(rate))
        givenLocalSaveRateResult(result: .success(rate))
        
        // when
        whenGetRate(id: rate.id)
        
        // then
        onExpectationFulfilled {
            XCTAssertNil(errorResult, "Unexpected error encountered when getting rate")
        }
    }
    
    
    
    func test_getRate_whenRemoteSucceds_localSavesData() {
        // given
        givenRemoteGetRateResult(result: .success(rate))
        givenLocalSaveRateResult(result: .success(rate))
        
        // when
        whenGetRate(id: rate.id)
        
        // then
        onExpectationFulfilled {
            XCTAssertEqual(local.saveRateCalls.filter { $0 == rate.id }.count, 1, "Unexpected number of save calls of local datastore")
        }
    }
    
    
    
    func test_getRate_whenRemoteFailsWithOtherThanNetworkError_errorIsReturned() {
        // given
        givenRemoteGetRateResult(result: .failure(CustomError.api(error: .assetNotFound)))
        givenLocalSaveRateResult(result: .success(rate))
        
        // when
        whenGetRate(id: rate.id)
        
        // then
        onExpectationFulfilled {
            XCTAssertNotNil(errorResult, "Error should exist when remote datastore fails with other than network error")
        }
    }
    
    
    
    func test_getRate_whenSaveLocalDatastoreFails_errorIsReturned() {
        // given
        givenRemoteGetRateResult(result: .success(rate))
        givenLocalSaveRateResult(result: .failure(CustomError.storage(.itemNotFound)))
        
        // when
        whenGetRate(id: rate.id)
        
        // then
        onExpectationFulfilled {
            XCTAssertNotNil(errorResult, "Error should exist when local datastore save fails")
        }
    }
    
    
    
    func test_getRate_whenRemoteFailsWithNetworkError_errorIsNotReturned() {
        // given
        givenRemoteGetRateResult(result: .failure(CustomError.networkOffline))
        givenLocalSaveRateResult(result: .success(rate))
        givenLocalGetRateResult(result: .success(rate))
        
        // when
        whenGetRate(id: rate.id)
        
        // then
        onExpectationFulfilled {
            XCTAssertNil(errorResult, "Unexpected error when remote datastore fails with network error")
        }
    }
    
    
    
    func test_getRate_whenRemoteFailsWithNetworkError_localRepoIsFetched() {
        // given
        givenRemoteGetRateResult(result: .failure(CustomError.networkOffline))
        givenLocalSaveRateResult(result: .success(rate))
        givenLocalGetRateResult(result: .success(rate))
        
        // when
        whenGetRate(id: rate.id)
        
        // then
        onExpectationFulfilled {
            XCTAssertEqual(local.getRateCalls.filter { $0 == rate.id }.count, 1, "Unexpected number of get calls of local datastore")
        }
    }
    
    
    
    // MARK: - helpers
    private func givenRemoteGetRateResult(result: ResponseResult<CryptoExchangeRate>) {
        remote.getRateResult = Deferred {
            Future { promise in
                switch result {
                case .success(let data): promise(.success(data))
                case .failure(let err): promise(.failure(err))
                }
            }
        }
        
        expectation = expectation(description: "waiting for result")
    }
    
    
    private func givenLocalSaveRateResult(result: ResponseResult<CryptoExchangeRate>) {
        local.saveRateResult = Deferred {
            Future { promise in
                switch result {
                case .success(let data): promise(.success(data))
                case .failure(let err): promise(.failure(err))
                }
            }
        }
    }
    
    
    private func givenLocalGetRateResult(result: ResponseResult<CryptoExchangeRate>) {
        local.getRateResult = Deferred {
            Future { promise in
                switch result {
                case .success(let data): promise(.success(data))
                case .failure(let err): promise(.failure(err))
                }
            }
        }
    }
    
    
    private func whenGetRate(id: String) {
        sut
            .getAssetExchangeRate(id: id, inCurrency: .euro)
            .sinkInto { _, error in
                self.errorResult = error
                self.expectation.fulfill()
            }
            .store(in: &cancellables)
    }
    
    
    private func onExpectationFulfilled(callback: () -> Void) {
        wait(for: [expectation], timeout: 1)
        callback()
    }
}
