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
    
    convenience init(refreshController: VaccinationCentersRefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    func set(_ controllers: [VaccinationCenterCellController]) {
        tableModels = controllers
        tableView.reloadData()
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
}
