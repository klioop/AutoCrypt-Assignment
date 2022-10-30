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
    
    private func configure() {
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
