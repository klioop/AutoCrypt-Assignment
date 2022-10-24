//
//  VaccinationCenterDetailCellController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/24.
//

import UIKit

final class VaccinationCenterDetailCellController {
    private let model: VaccinationCenterDetailModel
    
    init(model: VaccinationCenterDetailModel) {
        self.model = model
    }
    
    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "\(VaccinationCenterDetailCell.self)"), for: indexPath) as! VaccinationCenterDetailCell
        
        cell.image = model.image
        cell.title = model.title
        cell.descriptionText = model.description
        
        return cell
    }
}
