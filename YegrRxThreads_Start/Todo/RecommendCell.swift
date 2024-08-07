//
//  RecommendCell.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/7/24.
//

import UIKit
import SnapKit

final class RecommendCell: UICollectionViewCell {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configureLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
        
        titleLabel.textAlignment = .center
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
    }
}
