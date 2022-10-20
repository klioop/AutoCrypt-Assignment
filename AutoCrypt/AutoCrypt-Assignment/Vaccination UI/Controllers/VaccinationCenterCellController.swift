//
//  VaccinationCenterCellController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit

final class VaccinationCenterCellController {
    private let model: VaccinationCenter
    
    init(model: VaccinationCenter) {
        self.model = model
    }
    
    func view() -> UITableViewCell {
        let cell = VaccinationCenterCell()
        
        cell.nameLabel.text = model.name
        cell.facilityNameLabel.text = model.facilityName
        cell.addressLabel.text = model.address
        cell.updatedAtLabel.text = model.updatedAt
        return cell
    }
}
