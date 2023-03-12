//
//  VaccinationCenterMapViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import UIKit
import RxSwift
import RxCocoa

final class VaccinationCenterMapViewController: UIViewController {
    private let bag = DisposeBag()
    
    private var viewModel: VaccinationCenterMapViewModel?
    
    convenience init(viewModel: VaccinationCenterMapViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    var configure: ((UIView) -> Void)?
    
    override func loadView() {
        super.loadView()
        self.view = binded(VaccinationCenterMapMainView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.authorizationTrigger.accept(())
        configure?(view)
    }
    
    private func binded(_ view: VaccinationCenterMapMainView) -> VaccinationCenterMapMainView? {
        guard let viewModel = self.viewModel else { return nil }
        
        view.currentLocationButton
            .rx.tap.bind(to: viewModel.currentButtonTapInput)
            .disposed(by: bag)
        
        view.centerLocationButton
            .rx.tap.bind(to: viewModel.centerButtonTapInput)
            .disposed(by: bag)
        
        viewModel.state
            .subscribe(onNext: { state in
                switch state {
                case let .currentLocation(location):
                    view.currentCoordinate = .init(latitude: location.latitude, longitude: location.longitude)
                    
                case let .centerLocation(location):
                    view.centerInfo = (.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), location.name)
                    
                default: break
                }
            })
            .disposed(by: bag)
        
        return view
    }
}
