//
//  VaccinationCenterDetailView.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/23.
//

import UIKit
import SnapKit

final class VaccinationCenterDetailView: UIView, UIContentView {
    
    private(set) lazy var imageViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        
        imageViewContainer.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(75)
        }
        
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    private(set) lazy var container: UIView = {
        let view = UIView()
        
        [imageViewContainer, titleLabel, descriptionLabel].forEach {
            addSubview($0)
        }
        
        imageViewContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageViewContainer.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        return view
    }()
    
    var configuration: UIContentConfiguration {
        get { customConfiguration }
        set {
            if let newConfig = newValue as? VaccinationCenterConfiguration {
                apply(newConfig)
            }
        }
    }
    
    private let customConfiguration: VaccinationCenterConfiguration
    
    init(configuration: VaccinationCenterConfiguration) {
        self.customConfiguration = configuration
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3.0
        
        addSubview(container)
        container.snp.makeConstraints {
            $0.leading.trailing.equalTo(layoutMarginsGuide)
            $0.top.bottom.equalTo(layoutMarginsGuide)
        }
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func apply(_ config: VaccinationCenterConfiguration) {
        imageView.image = config.image
        titleLabel.text = config.title
        descriptionLabel.text = config.description
    }
}
