//
//  VaccinationCentersUIIntegrationTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/16.
//

import XCTest
import AutoCrypt_Assignment
import RxSwift

class VaccinationCentersUIIntegrationTests: XCTestCase {
    
    func test_requestLoadAction_requestsAListOfVaccinationCenter() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "생성시 요청하지 않는다")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "뷰가 로드되면 센터 리스트를 한 번 요청한다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(loader.loadCallCount, 2, "유저가 리로드 하면 센터 리스트를 한 번더 요청한다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(loader.loadCallCount, 3, "유저가 리로드를 한번 더 하면 센터 리스트를 세번 째 요청한다")
    }
    
    func test_requestLoadMoreAction_requestsLoadMoreAListOfVaccinationCenter() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: [])
        
        XCTAssertEqual(loader.loadMoreCallCount, 0, "추가적인 로드를 요청하지 않으면 추가적으로 로드를 요청하지 않는다")
        
        sut.simulateLoadMoreAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "추가적인 로드가 요청되면 센터 리스트를 더 요청한다")
        
        sut.simulateLoadMoreAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "요청된 로드가 끝나지 않는 도중에 한 번 더 리스트가 요청되면 리스트를 요청하지 않는다")
    }
    
    func test_userInitiateRequestLoading_showsLoadingIndicator() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "뷰가 로드 되면 로딩 인디케이터를 보여준다")
        
        loader.completeLoading(with: anyNSError(), at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "센터 리스트 로드가 실패로 끝나면 로딩 인디케이터를 보여주지 않는다")
        
        sut.simulateUserInitiateReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "유저가 리로드 하면 로딩 인디케이터를 보여준다")
        
        loader.completeLoading(with: [uniqueCenter()], at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "센터 리스트 리로드가 성공적으로 끝나면 로딩 인디케이터를 보여주지 않는다")
    }
    
    func test_successfulLoadCompletion_rendersCentersLoaded() {
        let (sut, loader) = makeSUT()
        let center0 = uniqueCenter(id: 1, name: "first center", facilityName: "first facility name", address: "first address", updatedAt: "2021-07-16 04:55:08")
        let center1 = uniqueCenter(id: 2, name: "second center", facilityName: "second facility name", address: "second address", updatedAt: "2021-07-17 04:55:08")
        
        sut.loadViewIfNeeded()
        loader.completeLoading(with: [center0, center1])
        
        assertThat(sut, isRendering: [center0, center1])
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: VaccinationCenterListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = VaccinationCentersUIComposer.vaccinationCenterListComposedWith(loadSingle: loader.loadSingle)
        trackMemoryLeak(loader, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: VaccinationCenterListViewController, isRendering models: [VaccinationCenter], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfCentersRendered == models.count else {
            return XCTFail("\(sut.numberOfCentersRendered) 은 \(models.count) 와 같아야 한다", file: file, line: line)
        }
        
        models.enumerated().forEach { row, center in
            assertThat(sut, configuresFor: center, at: row, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: VaccinationCenterListViewController, configuresFor center: VaccinationCenter, at row: Int, file: StaticString = #filePath, line: UInt = #line) {
        guard let centerView = sut.centerView(at: row) as? VaccinationCenterCell else {
            return XCTFail("\(row) 의 예방접종센터 셀은 존재해야 한다", file: file, line: line)
        }
        
        XCTAssertEqual(centerView.name, center.name, file: file, line: line)
        XCTAssertEqual(centerView.facilityName, center.facilityName, file: file, line: line)
        XCTAssertEqual(centerView.address, center.address, file: file, line: line)
        XCTAssertEqual(centerView.updatedAt, center.updatedAt, file: file, line: line)
    }
    
    private class LoaderSpy {
        private(set) var requestCompletions = [PublishSubject<Paginated<VaccinationCenter>>]()
        
        var loadCallCount: Int {
            requestCompletions.count
        }
        
        private(set) var loadMoreCallCount = 0
        
        func loadSingle() -> Single<Paginated<VaccinationCenter>> {
            let subject = PublishSubject<Paginated<VaccinationCenter>>()
            requestCompletions.append(subject)
            return subject.asSingle()
        }
        
        func completeLoading(with error: Error, at index: Int = 0) {
            requestCompletions[index].onError(error)
            requestCompletions[index].onCompleted()
        }
        
        func completeLoading(with centers: [VaccinationCenter], at index: Int = 0) {
            requestCompletions[index].onNext(Paginated(items: centers, loadMore: { [weak self] _ in
                self?.loadMoreCallCount += 1
            }))
            requestCompletions[index].onCompleted()
        }
    }
}

private extension VaccinationCenterListViewController {
    var isShowingLoadingIndicator: Bool {
        refreshControl!.isRefreshing
    }
    
    var numberOfCentersRendered: Int {
        tableView.numberOfRows(inSection: 0)
    }
    
    func centerView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let indexPath = IndexPath(row: row, section: listSection)
        return dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func simulateUserInitiateReload() {
        refreshControl?.sendActions(for: .valueChanged)
    }
    
    func simulateLoadMoreAction() {
        let scrollView = DraggingScrollView()
        scrollView.contentOffset.y = 1000
        scrollViewDidScroll(scrollView)
    }
    
    private var listSection: Int { 0 }
}

private class DraggingScrollView: UIScrollView {
    override var isDragging: Bool {
        true
    }
}

private extension VaccinationCenterCell {
    var name: String? {
        nameLabel.text
    }
    
    var facilityName: String? {
        facilityNameLabel.text
    }
    
    var address: String? {
        addressLabel.text
    }
    
    var updatedAt: String? {
        updatedAtLabel.text
    }
}
