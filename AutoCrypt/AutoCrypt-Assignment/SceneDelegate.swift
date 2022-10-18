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
    
    private lazy var remoteCenterListLoader = {
        let url = VaccinationCenterListEndPoint.get().url(with: baseURL)
        return RemoteVaccinationCentersLoader(url: url,
                                              client: httpClient)
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
        
        return remoteCenterListLoader
            .loadSingle()
            .map { [remoteCenterListLoader] items in
                Paginated(items: items, loadMoreSingle: {
                    let url = VaccinationCenterListEndPoint.get(2).url(with: baseURL)
                    return remoteCenterListLoader
                        .loadSingle()
                        .map { newItems in
                            Paginated(items: newItems, loadMoreSingle: {
                                Observable.empty().asSingle()
                            })
                        }
                })
            }
    }
}

