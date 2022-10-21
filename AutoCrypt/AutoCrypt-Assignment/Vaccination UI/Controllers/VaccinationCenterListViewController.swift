//
//  VaccinationCenterListViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit

public final class VaccinationCenterListViewController: UITableViewController {
    
    var callback: (() -> Void)?
    var refreshController: VaccinationCentersRefreshController?
    
    convenience init(refreshController: VaccinationCentersRefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    private(set) lazy var dataSource = UITableViewDiffableDataSource<Int, VaccinationCenterCellController>(tableView: tableView) { tableView, indexPath, controller in
        controller.view()
    }
    
    func set(_ controllers: [VaccinationCenterCellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, VaccinationCenterCellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(controllers, toSection: 0)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    func append(_ newControllers: [VaccinationCenterCellController]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(newControllers, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public override func viewDidLoad() {
        tableView.dataSource = dataSource
        
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            callback?()
        }
    }
}
