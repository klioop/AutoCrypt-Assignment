//
//  VaccinationCenterListViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit

public final class VaccinationCenterListViewController: UITableViewController {
    private var tableModels = [VaccinationCenterCellController]()
    
    var refreshController: VaccinationCentersRefreshController?
    var callback: (() -> Void)?
    
    convenience init(refreshController: VaccinationCentersRefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    func set(_ controllers: [VaccinationCenterCellController]) {
        tableModels = controllers
        tableView.reloadData()
    }
    
    func add(_ newControllers: [VaccinationCenterCellController]) {
        let startIndex = tableModels.count
        let endIndex = startIndex + newControllers.count
        tableModels += newControllers
        
        tableView.insertRows(at: (startIndex..<endIndex).map { row in IndexPath(row: row, section: 0) }, with: .none)
    }
    
    public override func viewDidLoad() {
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModels.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableModels[indexPath.row].view()
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) {
            callback?()
        }
    }
}
