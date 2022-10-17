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
        
        loader.completeLoadMore(lastPage: false, at: 0)
        sut.simulateLoadMoreAction()
        XCTAssertEqual(loader.loadMoreCallCount, 2, "추가적으로 요청된 로드가 성공적으로 끝나고, 리스트가 추가적으로 요청되면 리스트를 더 요청한다")
        
        loader.completeLoadMoreWithError(at: 1)
        sut.simulateLoadMoreAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "추가적으로 요청된 로드가 실패로 끝나고, 리스트가 추가적으로 요청되면 리스트를 요청한다")
        
        loader.completeLoadMore(lastPage: true, at: 2)
        sut.simulateLoadMoreAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "추가적으로 요청된 로드가 성공적으로 끝나고, 마지막 페이지면 추가로 더 리스트를 요청해도 리스트는 요청되지 않는다")
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
        let center2 = uniqueCenter(id: 3, name: "third center", facilityName: "third facility name", address: "first address", updatedAt: "2021-07-16 04:55:08")
        let center3 = uniqueCenter(id: 4, name: "fourth center", facilityName: "fourth facility name", address: "second address", updatedAt: "2021-07-17 04:55:08")
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeLoading(with: [center0, center1], at: 0)
        assertThat(sut, isRendering: [center0, center1])
        
        sut.simulateLoadMoreAction()
        loader.completeLoadMore(with: [center2, center3], at: 0)
        assertThat(sut, isRendering: [center0, center1, center2, center3])
        
        sut.simulateUserInitiateReload()
        loader.completeLoading(with: [center0, center1], at: 1)
        assertThat(sut, isRendering: [center0, center1])
    }
    
    func test_loadCentersCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let center = uniqueCenter()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoading(with: [center], at: 0)
        assertThat(sut, isRendering: [center])
        
        sut.simulateUserInitiateReload()
        loader.completeLoading(with: anyNSError(), at: 1)
        assertThat(sut, isRendering: [center])
        
        sut.simulateLoadMoreAction()
        loader.completeLoadMoreWithError()
        assertThat(sut, isRendering: [center])
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
        private(set) var loadMoreRequests = [PublishSubject<Paginated<VaccinationCenter>>]()
        
        var loadCallCount: Int {
            requestCompletions.count
        }
        
        var loadMoreCallCount: Int {
            loadMoreRequests.count
        }
        
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
            requestCompletions[index].onNext(Paginated(items: centers, loadMoreSingle: { [weak self] in
                let subject = PublishSubject<Paginated<VaccinationCenter>>()
                self?.loadMoreRequests.append(subject)
                return subject.asSingle()
            }))
            requestCompletions[index].onCompleted()
        }
        
        func completeLoadMore(with centers: [VaccinationCenter] = [], lastPage: Bool = false, at index: Int = 0) {
            loadMoreRequests[index].onNext(Paginated(
                items: centers,
                loadMoreSingle: lastPage ? nil : { [weak self] in
                    let subject = PublishSubject<Paginated<VaccinationCenter>>()
                    self?.loadMoreRequests.append(subject)
                    return subject.asSingle()
            }))
            loadMoreRequests[index].onCompleted()
        }
        
        func completeLoadMoreWithError(at index: Int = 0) {
            loadMoreRequests[index].onError(anyNSError())
            loadMoreRequests[index].onCompleted()
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
