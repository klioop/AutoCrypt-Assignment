//
//  VaccinationCentersUIIntegrationTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest
import AutoCrypt_Assignment

final class VaccinationCenterListViewController: UITableViewController {
    typealias LoadCompletion = (RemoteVaccinationCentersLoader.LoadResult) -> Void
    
    var load: ((@escaping LoadCompletion) -> Void)?
    
    convenience init(load: @escaping (@escaping LoadCompletion) -> Void) {
        self.init()
        self.load = load
    }
    
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refresh()
    }
    
    @objc private func refresh() {
        refreshControl?.beginRefreshing()
        load? { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

class VaccinationCentersUIIntegrationTests: XCTestCase {
    
    func test_userInitiateRequestLoading_requestsCenters() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "생성시 요청하지 않는다")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "뷰가 로드되면 센터 리스트를 한 번 요청한다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(loader.loadCallCount, 2, "유저가 리로드 하면 센터 리스트를 한 번더 요청한다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(loader.loadCallCount, 3, "유저가 리로드를 한번 더 하면 센터 리스트를 세번 째 요청한다")
    }
    
    func test_userInitiateRequestLoading_showsLoadingIndicator() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
        
        loader.completeLoading(with: anyNSError())
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
        
        loader.completeLoading(with: [uniqueCenter()])
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: VaccinationCenterListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = VaccinationCenterListViewController(load: loader.load)
        trackMemoryLeak(loader, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    
    private func anyNSError() -> NSError {
        NSError(domain: "a error", code: 0)
    }
    
    private func uniqueCenter(id: Int = 0,
                              name: String = "a name",
                              facilityName: String = "a facility name",
                              address: String = "a address",
                              lat: String = "1.0",
                              lng: String = "1.0",
                              updatedAt: String = "2021-07-16 04:55:08"
    ) -> VaccinationCenter {
        let centerID = CenterID(id: id)
        return VaccinationCenter(id: centerID, name: name, facilityName: facilityName, address: address, lat: lat, lng: lng, updatedAt: updatedAt)
    }
    
    private class LoaderSpy {
        private(set) var loadCallCount = 0
        private(set) var requestCompletions = [(RemoteVaccinationCentersLoader.LoadResult)-> Void]()
        
        func load(completion: @escaping (RemoteVaccinationCentersLoader.LoadResult) -> Void) {
            loadCallCount += 1
            requestCompletions.append(completion)
        }
        
        func completeLoading(with error: Error, at index: Int = 0) {
            requestCompletions[index](.failure(error))
        }
        
        func completeLoading(with centers: [VaccinationCenter], at index: Int = 0) {
            requestCompletions[index](.success(centers))
        }
    }

}

private extension VaccinationCenterListViewController {
    var isShowingLoadingIndicator: Bool {
        refreshControl!.isRefreshing
    }
    
    func simulateUserInitiateReload() {
        refreshControl?.sendActions(for: .valueChanged)
    }
}
