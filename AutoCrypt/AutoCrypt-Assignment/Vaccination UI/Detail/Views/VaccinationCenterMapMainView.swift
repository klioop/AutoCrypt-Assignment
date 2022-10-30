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
    private(set) lazy var mapView = MKMapView()
    
    private(set) lazy var attributeContainer: AttributeContainer = {
        var container = AttributeContainer()
        container.foregroundColor = .white
        return container
    }()
    
    private(set) lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        var config = button.configuration
        config?.background.backgroundColor = .blue
        config?.attributedTitle = AttributedString("현재위치로 이동", attributes: attributeContainer)
        button.configuration = config
        return button
    }()
    
    private(set) lazy var centerLocationButton: UIButton = {
        let button = UIButton()
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
        [mapView, currentLocationButton, centerLocationButton].forEach { addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        centerLocationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
