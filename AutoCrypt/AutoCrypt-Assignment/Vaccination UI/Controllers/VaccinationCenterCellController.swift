//
//  VaccinationCenterCellController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit
import RxDataSources

final class VaccinationCenterCellController {
    private let model: VaccinationCenter
    private let selection: () -> Void
    
    init(model: VaccinationCenter, selection: @escaping () -> Void) {
        self.model = model
        self.selection = selection
    }
    
    func view() -> UITableViewCell {
        let cell = VaccinationCenterCell()
        
        cell.nameLabel.text = model.name
        cell.facilityNameLabel.text = model.facilityName
        cell.addressLabel.text = model.address
        cell.updatedAtLabel.text = model.updatedAt
        return cell
    }
    
    func select() {
        selection()
    }
}

extension VaccinationCenterCellController: Equatable {
    static func ==(lhs: VaccinationCenterCellController, rhs: VaccinationCenterCellController) -> Bool {
        lhs.model == rhs.model
    }
}

extension VaccinationCenterCellController: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
}

extension VaccinationCenterCellController: IdentifiableType {
    var identity: some Hashable {
        model
    }
}
