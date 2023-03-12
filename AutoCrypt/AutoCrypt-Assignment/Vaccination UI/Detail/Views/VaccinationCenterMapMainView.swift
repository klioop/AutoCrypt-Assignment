//
//  VaccinationCenterMapMainView.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import UIKit
import SnapKit
import MapKit

final class VaccinationCenterMapMainView: UIView {
    var currentCoordinate: CLLocationCoordinate2D {
        get { mapView.region.center }
        set {
            setRegion(with: newValue, animated: true)
        }
    }
    
    var centerInfo: (coordinate: CLLocationCoordinate2D, name: String) {
        get { (mapView.region.center, "name") }
        set {
            count += 1
            setRegion(with: newValue.coordinate, animated: animated)
            addAnnotation(for: newValue.coordinate, with: newValue.name)
        }
    }
    
    private(set) lazy var mapView: MKMapView = {
        let view = MKMapView()
        
        view.showsUserLocation = true
        return view
    }()
    
    private(set) lazy var attributeContainer: AttributeContainer = {
        var container = AttributeContainer()
        
        container.foregroundColor = .white
        return container
    }()
    
    private(set) lazy var currentLocationButton: UIButton = {
        let button = UIButton(configuration: .filled())
        var config = button.configuration
        
        config?.background.backgroundColor = .blue
        config?.attributedTitle = AttributedString("현재위치로 이동", attributes: attributeContainer)
        button.configuration = config
        return button
    }()
    
    private(set) lazy var centerLocationButton: UIButton = {
        let button = UIButton(configuration: .filled())
        var config = button.configuration
        
        config?.background.backgroundColor = .red
        config?.attributedTitle = AttributedString("예방접종센터 위치로 이동", attributes: attributeContainer)
        button.configuration = config
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private var animated: Bool {
        count == 1 ? false : true
    }
    
    private var count = 0
    
    private func setRegion(with coordinate: CLLocationCoordinate2D, animated: Bool) {
        mapView.setRegion(mkRegion(from: coordinate), animated: animated)
    }
    
    private func addAnnotation(for coordinate: CLLocationCoordinate2D, with title: String) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Helpers
    
    private func mkRegion(from coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        [mapView].forEach { addSubview($0) }
        mapView.addSubview(currentLocationButton)
        mapView.addSubview(centerLocationButton)
        
        mapView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        centerLocationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(60)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(56)
            $0.bottom.equalTo(centerLocationButton.snp.top).inset(-10)
        }
    }
}
