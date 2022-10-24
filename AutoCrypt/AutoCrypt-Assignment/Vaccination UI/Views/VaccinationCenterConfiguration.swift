//
//  VaccinationCenterConfiguration.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/23.
//

import UIKit

struct VaccinationCenterConfiguration: UIContentConfiguration {
    
    func makeContentView() -> UIView & UIContentView {
        VaccinationCenterDetailView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> VaccinationCenterConfiguration {
        self
    }
}
