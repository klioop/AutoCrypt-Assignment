//
//  SceneDelegate.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var baseURL = URL(string: "https://api.odcloud.kr/api")!
        
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: .shared)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let centerListController = VaccinationCentersUIComposer.vaccinationCenterListComposedWith(
            loadSingle: makeRemoteCenterListLoader)
        
        window?.rootViewController = UINavigationController(rootViewController: centerListController)
        window?.makeKeyAndVisible()
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

