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
            .map { items in
                Paginated(items: items)
            }
    }
}

