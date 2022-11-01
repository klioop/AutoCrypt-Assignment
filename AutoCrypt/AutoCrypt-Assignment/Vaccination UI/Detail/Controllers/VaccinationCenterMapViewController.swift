//
//  VaccinationCenterMapViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

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
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.authorizationTrigger.accept(())
        viewModel?.currentButtonViewModel.tap.accept(())
    }
    
    func bind() {
        guard let viewModel = self.viewModel else { return }
        
        mainView.currentLocationButton
            .rx.tap.bind(to: viewModel.currentButtonViewModel.tap)
            .disposed(by: bag)
        
        mainView.centerLocationButton
            .rx.tap.bind(to: viewModel.centerButtonViewModel.tap)
            .disposed(by: bag)
        
        viewModel.state
            .subscribe(onNext: { [weak mainView] state in
                switch state {
                case let .currentLocation(viewModel):
                    mainView?.mapView.setRegion(MKCoordinateRegion(center: viewModel.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
                    
                case let .centerLocation(viewModel):
                    let region = MKCoordinateRegion(center: viewModel.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    mainView?.mapView.setRegion(region, animated: true)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = region.center
                    mainView?.mapView.addAnnotation(annotation)
                    
                default: break
                }
            })
            .disposed(by: bag)
    }
}
