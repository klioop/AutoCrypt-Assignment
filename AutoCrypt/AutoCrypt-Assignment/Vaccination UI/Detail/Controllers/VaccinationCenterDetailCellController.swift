//
//  VaccinationCenterDetailCellController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/24.
//

import UIKit

final class VaccinationCenterDetailCellController {
    private let model: VaccinationCenterDetail
    
    init(model: VaccinationCenterDetail) {
        self.model = model
    }
    
    static func register(for collectionView: UICollectionView) {
        collectionView.register(VaccinationCenterDetailCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VaccinationCenterDetailCell
        
        cell.image = model.image
        cell.title = model.title
        cell.descriptionText = model.description
        
        return cell
    }
}
