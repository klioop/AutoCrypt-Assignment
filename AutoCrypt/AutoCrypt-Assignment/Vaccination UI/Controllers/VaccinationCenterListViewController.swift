//
//  VaccinationCenterListViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources

public final class VaccinationCenterListViewController: UITableViewController {
    private let bag = DisposeBag()
    private let centerListRelay = BehaviorRelay<[Section]>(value: [])
    
    var callback: (() -> Void)?
    var refreshController: VaccinationCentersRefreshController?
    
    convenience init(refreshController: VaccinationCentersRefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    typealias Section = AnimatableSectionModel<String, VaccinationCenterCellController>
    
    private(set) lazy var dataSource = RxTableViewSectionedAnimatedDataSource<Section> {
        (dataSource, tableView, indexPath, controller) in
        controller.view()
    }
    
    func set(_ controllers: [VaccinationCenterCellController]) {
        centerListRelay.accept(sections(with: controllers))
    }
    
    func append(_ newControllers: [VaccinationCenterCellController]) {
        centerListRelay.accept(sections(with: centerListRelay.value[0].items + newControllers))
    }
    
    private func sections(with controllers: [VaccinationCenterCellController]) -> [Section] {
        [AnimatableSectionModel(model: "section", items: controllers)]
    }
    
    public override func viewDidLoad() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        centerListRelay
            .skip(1)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
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
