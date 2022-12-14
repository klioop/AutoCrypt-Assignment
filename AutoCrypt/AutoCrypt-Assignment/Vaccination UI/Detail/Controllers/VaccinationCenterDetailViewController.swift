//
//  VaccinationCenterDetailViewController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/24.
//

import UIKit

final class VaccinationCenterDetailViewController: UICollectionViewController {
    
    var collectionModels = [[VaccinationCenterDetailCellController]]()
    
    private lazy var layout = createLayout()
    
    convenience init() {
        self.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    var configure: ((UICollectionView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .systemGray5
        configure?(collectionView)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionModels[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionModels[indexPath.section][indexPath.row].view(in: collectionView, for: indexPath)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let columns = section == 0 ? 2 : 1
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(210))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(20)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            return section
        }
        return layout
    }
}
