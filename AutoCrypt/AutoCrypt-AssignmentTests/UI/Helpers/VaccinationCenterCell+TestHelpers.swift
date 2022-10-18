//
//  VaccinationCenterCell+TestHelpers.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/18.
//

import XCTest
import AutoCrypt_Assignment

extension VaccinationCenterCell {
    var name: String? {
        nameLabel.text
    }
    
    var facilityName: String? {
        facilityNameLabel.text
    }
    
    var address: String? {
        addressLabel.text
    }
    
    var updatedAt: String? {
        updatedAtLabel.text
    }
}
