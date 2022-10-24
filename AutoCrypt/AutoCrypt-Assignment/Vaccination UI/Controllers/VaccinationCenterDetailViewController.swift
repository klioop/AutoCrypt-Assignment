//
//  VaccinationCenterDetailViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/24.
//

import UIKit

final class VaccinationCenterDetailViewController: UICollectionViewController {
    
    private var collectionModels = [VaccinationCenterDetailCellController]()
    
    override func viewDidLoad() {
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? 4 : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionModels[indexPath.row].view(in: collectionView, for: indexPath)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let columns = section == 0 ? 2 : 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}
