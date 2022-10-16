//
//  VaccinationCentersUIIntegrationTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest

final class VaccinationCenterListViewController: UIViewController {
    
}

class VaccinationCentersUIIntegrationTests: XCTestCase {
    
    func test_init_doesNotSendAnyMessage() {
        let loader = LoaderSpy()
        _ = VaccinationCenterListViewController()
        
        XCTAssertTrue(loader.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private class LoaderSpy {
        private(set) var messages = [Any]()
    }
}
