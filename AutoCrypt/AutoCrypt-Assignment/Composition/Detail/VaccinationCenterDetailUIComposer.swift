//
//  VaccinationCenterDetailUIComposer.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/24.
//

import UIKit

class VaccinationCenterDetailUIComposer {
    static func makeDetailViewController(for model: VaccinationCenter, didTapBarItem: @escaping () -> Void) -> VaccinationCenterDetailViewController {
        let detailViewController = VaccinationCenterDetailViewController()
        detailViewController.configure = { [weak detailViewController] in
            VaccinationCenterDetailCellController.register(for: $0)
            detailViewController?.collectionModels = makeSections(from: model)
            detailViewController?.collectionView.reloadData()
        }
        detailViewController.title = model.name
        detailViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "지도", primaryAction: UIAction { _ in
            didTapBarItem()
        })
        return detailViewController
    }
    
    private static func makeCellControllersForFirstSection(from model: VaccinationCenter) -> [VaccinationCenterDetailCellController] {
        let center = VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "hospital"), title: "센터명", description: model.name))
        let facility = VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "building"), title: "건물명", description: model.facilityName))
        let phoneNumber = VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "telephone"), title: "전화번호", description: model.phoneNumber))
        let updatedAt = VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "chat"), title: "업데이트 시간", description: model.updatedAt))
        return [center, facility, phoneNumber, updatedAt]
    }
    
    private static func makeCellControllersForSecondSection(from model: VaccinationCenter) -> [VaccinationCenterDetailCellController] {
        [VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "placeholder"), title: "주소", description: model.address))]
    }
    
    private static func makeSections(from model: VaccinationCenter) -> [[VaccinationCenterDetailCellController]] {
        [makeCellControllersForFirstSection(from: model), makeCellControllersForSecondSection(from: model)]
    }
}


