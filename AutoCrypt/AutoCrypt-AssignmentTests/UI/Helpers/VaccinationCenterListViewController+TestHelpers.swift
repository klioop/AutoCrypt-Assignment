//
//  VaccinationCenterListViewController+TestHelpers.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/18.
//

import XCTest
import AutoCrypt_Assignment

private class NoAnimationTableView: UITableView {
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.insertRows(at: indexPaths, with: .none)
    }
}

extension VaccinationCenterListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        tableView = NoAnimationTableView()
    }
    
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
