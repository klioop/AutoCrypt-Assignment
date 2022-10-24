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
        }
        
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private(set) lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        
        [imageViewContainer, titleLabel, descriptionLabel].forEach {
            stack.addArrangedSubview($0)
        }
        
        return stack
    }()
    
    var configuration: UIContentConfiguration {
        get { customConfiguration }
        set { }
    }
    
    private let customConfiguration: VaccinationCenterConfiguration
    
    init(configuration: VaccinationCenterConfiguration) {
        self.customConfiguration = configuration
        super.init(frame: .zero)
        
        addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}
