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
    
    private var mainView: VaccinationCenterMapMainView {
        view as! VaccinationCenterMapMainView
    }
    
    override func loadView() {
        super.loadView()
        self.view = VaccinationCenterMapMainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        viewModel?.authorizationTrigger.accept(())
    }
    
    func bind() {
        guard let viewModel = self.viewModel else { return }
        
        mainView.currentLocationButton
            .rx.tap.bind(to: viewModel.currentButtonViewModel.tap)
            .disposed(by: bag)
        
        mainView.centerLocationButton
            .rx.tap.bind(to: viewModel.vaccinationButtonViewModel.tap)
            .disposed(by: bag)
        
        viewModel.state
            .subscribe(onNext: { [weak mainView] state in
                switch state {
                case let .location(region: region):
                    mainView?.mapView.setRegion(region, animated: true)
                    
                default: break
                }
            })
            .disposed(by: bag)
    }
}
