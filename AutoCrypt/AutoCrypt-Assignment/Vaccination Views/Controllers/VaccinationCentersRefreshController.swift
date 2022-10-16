//
//  VaccinationCentersRefreshController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit

final class VaccinationCentersRefreshController: NSObject {
    typealias LoadCompletion = (RemoteVaccinationCentersLoader.LoadResult) -> Void
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let load: (@escaping LoadCompletion) -> Void
    
    init(load: @escaping (@escaping LoadCompletion) -> Void) {
        self.load = load
    }
    
    var onRefresh: (([VaccinationCenter]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        load { [weak self] result in
            switch result {
            case let .success(centers):
                self?.onRefresh?(centers)
                
            case .failure: break
            }
            self?.view.endRefreshing()
        }
    }
}
