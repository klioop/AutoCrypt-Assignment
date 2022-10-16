//
//  VaccinationCenterListViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit

public final class VaccinationCenterListViewController: UITableViewController {
    public typealias LoadCompletion = (RemoteVaccinationCentersLoader.LoadResult) -> Void
    private var tableModels = [VaccinationCenter]()
    
    private var load: ((@escaping LoadCompletion) -> Void)?
    
    public convenience init(load: @escaping (@escaping LoadCompletion) -> Void) {
        self.init()
        self.load = load
    }
    
    public override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refresh()
    }
    
    @objc private func refresh() {
        refreshControl?.beginRefreshing()
        load? { [weak self] result in
            switch result {
            case let .success(centers):
                self?.tableModels = centers
                
            case .failure: break
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModels.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VaccinationCenterCell()
        let model = tableModels[indexPath.row]
        
        cell.nameLabel.text = model.name
        cell.facilityNameLabel.text = model.facilityName
        cell.addressLabel.text = model.address
        cell.updatedAtLabel.text = model.updatedAt
        return cell
    }
}
