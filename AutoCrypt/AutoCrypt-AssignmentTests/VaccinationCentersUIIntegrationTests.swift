//
//  VaccinationCentersUIIntegrationTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest
import AutoCrypt_Assignment

final class VaccinationCenterListViewController: UITableViewController {
    typealias LoadCompletion = (Result<[VaccinationCenter], RemoteVaccinationCentersLoader.Error>) -> Void
    
    var load: ((LoadCompletion) -> Void)?
    
    convenience init(load: @escaping (LoadCompletion) -> Void) {
        self.init()
        self.load = load
    }
    
    override func viewDidLoad() {
        refresh()
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        load? { _ in }
    }
}

class VaccinationCentersUIIntegrationTests: XCTestCase {
    
    func test_userInitiateRequestLoading_requestsCenters() {
        let loader = LoaderSpy()
        let sut = VaccinationCenterListViewController(load: loader.load)
        
        XCTAssertEqual(loader.loadCallCount, 0, "생성시 요청하지 않는다")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "뷰가 로드되면 센터 리스트를 한 번 요청한다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(loader.loadCallCount, 2, "유저가 리로드 하면 센터 리스트를 한 번더 요청한다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(loader.loadCallCount, 3, "유저가 리로드를 한번 더 하면 센터 리스트를 세번 째 요청한다")
    }

    // MARK: - Helpers
    
    private class LoaderSpy {
        private(set) var loadCallCount = 0
        
        func load(completion: (Result<[VaccinationCenter], RemoteVaccinationCentersLoader.Error>) -> Void) {
            loadCallCount += 1
        }
    }
}

private extension VaccinationCenterListViewController {
    func simulateUserInitiateReload() {
        refreshControl?.sendActions(for: .valueChanged)
    }
}
