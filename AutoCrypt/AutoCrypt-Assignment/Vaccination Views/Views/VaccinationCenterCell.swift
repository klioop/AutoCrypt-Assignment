//
//  VaccinationCenterCell.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit
import SnapKit

public final class VaccinationCenterCell: UITableViewCell {
    private(set) lazy var indicatorLabelContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        let center = indicatorLabel(with: "센터명")
        let facility = indicatorLabel(with: "건물명")
        let address = indicatorLabel(with: "주소")
        let updateAt = indicatorLabel(with: "업데이트 시간")
        
        [center, facility, address, updateAt].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private(set) lazy var descriptionLabelContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        [nameLabel, facilityNameLabel, addressLabel, updatedAtLabel].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    private(set) lazy var topContainerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(indicatorLabelContainer)
        stack.addArrangedSubview(descriptionLabelContainer)
        return stack
    }()
    
    private(set) public lazy var nameLabel = descriptionLabel()
    private(set) public lazy var facilityNameLabel = descriptionLabel()
    private(set) public lazy var addressLabel = descriptionLabel()
    private(set) public lazy var updatedAtLabel = descriptionLabel()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(topContainerView)
        topContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Helpers
    
    private func indicatorLabel(with name: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .systemGray
        label.text = name
        return label
    }
    
    private func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }
}
