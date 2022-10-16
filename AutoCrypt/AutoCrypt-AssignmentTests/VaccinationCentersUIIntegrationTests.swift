//
//  VaccinationCentersUIIntegrationTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest
import AutoCrypt_Assignment

final class VaccinationCenterListViewController: UIViewController {
    
    typealias LoadCompletion = (Result<[VaccinationCenter], RemoteVaccinationCentersLoader.Error>) -> Void
    
    var load: ((LoadCompletion) -> Void)?
    
    convenience init(load: @escaping (LoadCompletion) -> Void) {
        self.init()
        self.load = load
    }
    
    override func viewDidLoad() {
        self.load? { _ in }
    }
}

class VaccinationCentersUIIntegrationTests: XCTestCase {
    
    func test_init_doesNotSendAnyMessage() {
        let loader = LoaderSpy()
        _ = VaccinationCenterListViewController(load: loader.load)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_requestsCenters() {
        let loader = LoaderSpy()
        let sut = VaccinationCenterListViewController(load: loader.load)

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    // MARK: - Helpers
    
    private class LoaderSpy {
        private(set) var loadCallCount = 0
        
        func load(completion: (Result<[VaccinationCenter], RemoteVaccinationCentersLoader.Error>) -> Void) {
            loadCallCount += 1
        }
    }
}
