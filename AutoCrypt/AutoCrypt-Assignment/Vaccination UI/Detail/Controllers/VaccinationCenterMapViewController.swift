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
    
    override func loadView() {
        super.loadView()
        self.view = binded(VaccinationCenterMapMainView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.authorizationTrigger.accept(())
        viewModel?.currentButtonTapInput.accept(())
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
                    view.currentCoordinate = location.coordinate
                    
                case let .centerLocation(location):
                    view.centerInfo = (location.coordinate, location.name)
                    
                default: break
                }
            })
            .disposed(by: bag)
        
        return view
    }
}
