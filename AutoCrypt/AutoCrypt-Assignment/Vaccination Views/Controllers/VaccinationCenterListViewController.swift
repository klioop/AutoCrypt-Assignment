//
//  VaccinationCenterListViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit

public final class VaccinationCenterListViewController: UITableViewController {
    public typealias LoadCompletion = (RemoteVaccinationCentersLoader.LoadResult) -> Void
    private var tableModels = [VaccinationCenterCellController]()
    
    var refreshController: VaccinationCentersRefreshController?
    
    public convenience init(load: @escaping (@escaping LoadCompletion) -> Void) {
        self.init()
        self.refreshController = VaccinationCentersRefreshController(load: load)
        refreshController?.onRefresh = { [weak self] centers in
            self?.tableModels = centers.map { VaccinationCenterCellController(model: $0) }
        }
    }
    
    public override func viewDidLoad() {
        self.refreshControl = refreshController?.view
        
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModels.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableModels[indexPath.row].view()
    }
}
