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
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case let .currentLocation(location):
                    view.mapView.setRegion(self.mkRegion(from: location.coordinate), animated: true)
                    
                case let .centerLocation(location):
                    view.mapView.setRegion(self.mkRegion(from: location.coordinate), animated: true)
                    view.mapView.addAnnotation(self.annotation(from: location.coordinate, with: location.name))
                    
                default: break
                }
            })
            .disposed(by: bag)
        
        return view
    }
    
    private func mkRegion(from coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    private func annotation(from coordinate: CLLocationCoordinate2D, with title: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        return annotation
    }
}
