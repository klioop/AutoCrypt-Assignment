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
        viewModel?.currentButtonTapInput.accept(())
    }
    
    func bind() {
        guard let viewModel = self.viewModel else { return }
        
        mainView.currentLocationButton
            .rx.tap.bind(to: viewModel.currentButtonTapInput)
            .disposed(by: bag)
        
        mainView.centerLocationButton
            .rx.tap.bind(to: viewModel.centerButtonTapInput)
            .disposed(by: bag)
        
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case let .currentLocation(location):
                    self.mainView.mapView.setRegion(self.mkRegion(from: location.coordinate), animated: true)
                    
                case let .centerLocation(location):
                    self.mainView.mapView.setRegion(self.mkRegion(from: location.coordinate), animated: true)
                    self.mainView.mapView.addAnnotation(self.annotation(from: location.coordinate, with: location.name))
                    
                default: break
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Helpers
    
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
