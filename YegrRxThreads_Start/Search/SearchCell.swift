//
//  SearchCell.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchCell: UITableViewCell, ViewRepresentable {
    let titleLabel = UILabel()

    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        titleLabel.textAlignment = .left
    }
}
