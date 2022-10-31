//
//  SceneDelegate.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit
import RxSwift
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var baseURL = URL(string: "https://api.odcloud.kr/api")!
        
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: .shared)
    }()
    
    private lazy var navigationController = UINavigationController(rootViewController: VaccinationCentersUIComposer.vaccinationCenterListComposedWith(
        loadSingle: makeRemoteCenterListLoader,
        selection: showDetail))

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene), !isRunningUnitTests() else { return }
        window = UIWindow(windowScene: scene)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func isRunningUnitTests() -> Bool {
        NSClassFromString("XCTestCase") != nil
    }
    
    private func showDetail(for center: VaccinationCenter) {
        let detailController = VaccinationCenterDetailUIComposer.makeDetailViewController(for: center, didTapBarItem: { [weak self] in
            self?.showMap(for: center)
        })
        navigationController.pushViewController(detailController, animated: true)
    }
    
    private func showMap(for center: VaccinationCenter) {
        guard let latitude = Double(center.lat), let longitude = Double(center.lng) else { return }
        
        let manager = CLLocationManager()
        let locationService = LocationService(manager: manager)
        let currentLocationButtonViewModel = LocationButtonViewModel()
        let centerLocationButtonViewModel = LocationButtonViewModel()
        let locationViewModel = VaccinationCenterLocationViewModel(coordinate: .init(latitude: .init(latitude),
                                                                                     longitude: .init(longitude)),
                                                                   span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let viewModel = VaccinationCenterMapViewModel(locationViewModel: locationViewModel,
                                                      centerButtonViewModel: centerLocationButtonViewModel,
                                                      currentButtonViewModel: currentLocationButtonViewModel,
                                                      authorization: locationService.startAuthorization,
                                                      currentLocation: locationService.currentLocation)
        let mapViewController = VaccinationCenterMapViewController(viewModel: viewModel)
        mapViewController.title = "지도"
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
    private func makeRemoteCenterListLoader() -> Single<Paginated<VaccinationCenter>> {
        let baseURL = baseURL
        
        return httpClient
            .getSingle(from: VaccinationCenterListEndPoint.get().url(with: baseURL))
            .map(VaccinationCenterMapper.map)
            .map { [weak self] items in
                Paginated(items: items, loadMoreSingle: self?.loadMoreCenterListLoader(lastPage: 1))
            }
    }
    
    private func loadMoreCenterListLoader(lastPage: Int) -> (() -> Single<Paginated<VaccinationCenter>>)? {
        let baseURL = baseURL
        
        return { [weak self, httpClient] in
            httpClient
                .getSingle(from: VaccinationCenterListEndPoint.get(lastPage + 1).url(with: baseURL))
                .map(VaccinationCenterMapper.map)
                .map { newItems in
                    Paginated(items: newItems, loadMoreSingle: newItems.isEmpty ? nil : self?.loadMoreCenterListLoader(lastPage: lastPage + 1))
                }
        }
    }
}

