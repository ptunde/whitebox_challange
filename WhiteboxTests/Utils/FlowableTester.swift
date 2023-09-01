//
//  FlowableTester.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import Foundation
import Combine



class FlowableTester<T, F: Error> {
    
    private let flowable: AnyPublisher<T, F>
    private var values = [T]()
    private var cancellables = Set<AnyCancellable>()
    
    var onUpdate: ((T, Int) -> Void)? = nil
    
    var numberOfValues: Int
    { get { values.count } }
    
    
    
    // MARK: - init
    init(flowable: AnyPublisher<T, F>) {
        self.flowable = flowable
        
        flowable
            .sink { completion in
                // no-op
            } receiveValue: { value in
                self.values.append(value)
                self.onUpdate?(value, self.values.count - 1)
            }
            .store(in: &cancellables)
    }
    
    
    
    // MARK: - impl
    func value(at pos: Int) -> T {
        values[pos]
    }
    
    
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables = Set<AnyCancellable>()
    }
}
