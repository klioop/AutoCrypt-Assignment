//
//  VaccinationCentersViewModelTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/22.
//

import XCTest
import AutoCrypt_Assignment
import RxSwift

class VaccinationCentersViewModelTests: XCTestCase {
    
    func test_successfulLoadedState_createsLoadedStateStreamWithLoadingStates() {
        let page = makePage(with: [uniqueCenter()])
        let loader = LoaderStub(stub: .init(item: makePage(with: [uniqueCenter()]), error: nil))
        let sut = VaccinationCentersViewModel(loadSingle: loader.loadSingle)
        let state = StateSpy(sut.state)
        
        sut.loadTrigger.accept(())
        
        XCTAssertEqual(state.values, [.loading(true), .loaded(page), .loading(false)])
    }
    
    // MARK: - Helpers
    
    private func makePage(with items: [VaccinationCenter]) -> Paginated<VaccinationCenter> {
        Paginated(items: items)
    }
    
    private class StateSpy {
        private let bag = DisposeBag()
        private(set) var values = [VaccinationCentersViewModel.State]()
        
        init(_ state: Observable<VaccinationCentersViewModel.State>) {
            state
                .subscribe(onNext: { [weak self] in
                    self?.values.append($0)
                }).disposed(by: bag)
        }
    }
    
    private class LoaderStub {
        let stub: Stub
        
        struct Stub {
            let item: Paginated<VaccinationCenter>?
            let error: Error?
        }
        
        init(stub: Stub) {
            self.stub = stub
        }
        
        func loadSingle() -> Single<Paginated<VaccinationCenter>> {
            Single.create { [weak self] observer in
                if let error = self?.stub.error {
                    observer(.failure(error))
                }
                if let item = self?.stub.item {
                    observer(.success(item))
                }
                
                return Disposables.create()
            }
        }
    }
}
