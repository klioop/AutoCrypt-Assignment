//
//  VaccinationCenterDetailCell.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/24.
//

import UIKit

final class VaccinationCenterDetailCell: UICollectionViewCell {
    var image: UIImage? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    var title: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    var descriptionText: String? {
        didSet { setNeedsUpdateConfiguration() }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var config = VaccinationCenterConfiguration().updated(for: state)
        config.image = image
        config.title = title
        config.description = descriptionText
        contentConfiguration = config
    }
}
