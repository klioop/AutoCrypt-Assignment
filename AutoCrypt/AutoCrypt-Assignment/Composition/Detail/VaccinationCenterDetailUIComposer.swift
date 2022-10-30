//
//  VaccinationCenterDetailUIComposer.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/24.
//

import UIKit
import CoreLocation

class VaccinationCenterDetailUIComposer {
    static func makeDetailViewController(for model: VaccinationCenter) -> VaccinationCenterDetailViewController {
        let detailViewController = VaccinationCenterDetailViewController()
        detailViewController.configure = { [weak detailViewController] in
            VaccinationCenterDetailCellController.register(for: $0)
            detailViewController?.collectionModels = makeSections(from: model)
            detailViewController?.collectionView.reloadData()
        }
        detailViewController.title = model.name
        detailViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "지도", primaryAction: UIAction { [weak detailViewController] _ in
            guard let latitude = Double(model.lat), let longitude = Double(model.lng) else { return }
            
            let manager = CLLocationManager()
            let locationService = LocationService(manager: manager)
            let currentLocationButtonViewModel = LocationButtonViewModel()
            let centerLocationButtonViewModel = LocationButtonViewModel()
            let locationViewModel = VaccinationCenterLocationViewModel(coordinate: .init(latitude: .init(latitude), longitude: .init(longitude)),
                                                                       span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01),
                                                                       currentLocation: locationService.currentLocation)
            
            let viewModel = VaccinationCenterMapViewModel(locationViewModel: locationViewModel,
                                                          centerButtonViewModel: centerLocationButtonViewModel,
                                                          currentButtonViewModel: currentLocationButtonViewModel,
                                                          start: locationService.startAuthorization)
            let vc = VaccinationCenterMapViewController(viewModel: viewModel)
            vc.title = "지도"
            detailViewController?.navigationController?.pushViewController(vc, animated: true)
        })
        return detailViewController
    }
    
    private static func makeCellControllersForFirstSection(from model: VaccinationCenter) -> [VaccinationCenterDetailCellController] {
        let center = VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "hospital"), title: "센터명", description: model.name))
        let facility = VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "building"), title: "건물명", description: model.facilityName))
        let phoneNumber = VaccinationCenterDetailCellController(model: .init(image: UIImage(named: "telephone"), title: "전화번호", description: model.lat))
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


