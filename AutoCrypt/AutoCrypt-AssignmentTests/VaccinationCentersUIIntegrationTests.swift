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
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "뷰가 로드 되면 로딩 인디케이터를 보여준다")
        
        loader.completeLoading(with: anyNSError())
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "센터 리스트 로드가 실패로 끝나면 로딩 인디케이터를 보여주지 않는다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "유저가 리로드 하면 로딩 인디케이터를 보여준다")
        
        loader.completeLoading(with: [uniqueCenter()])
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "센터 리스트 리로드가 성공적으로 끝나면 로딩 인디케이터를 보여주지 않는다")
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: VaccinationCenterListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = VaccinationCenterListViewController(load: loader.load)
        trackMemoryLeak(loader, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private class LoaderSpy {
        private(set) var requestCompletions = [(RemoteVaccinationCentersLoader.LoadResult)-> Void]()
        
        var loadCallCount: Int {
            requestCompletions.count
        }
        
        func load(completion: @escaping (RemoteVaccinationCentersLoader.LoadResult) -> Void) {
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
