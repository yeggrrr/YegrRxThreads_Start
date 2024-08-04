//
//  TodoListCell.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TodoListCell: UITableViewCell, ViewRepresentable {
    let checkButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let starButton = UIButton(type: .system)

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
        contentView.addSubviews([checkButton, titleLabel, starButton])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        checkButton.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(10)
            $0.verticalEdges.equalTo(safeArea).inset(10)
            $0.width.equalTo(checkButton.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(20)
            $0.verticalEdges.equalTo(safeArea).inset(10)
            $0.trailing.equalTo(starButton.snp.leading).offset(-20)
        }
        
        starButton.snp.makeConstraints {
            $0.trailing.verticalEdges.equalTo(safeArea).inset(10)
            $0.width.equalTo(starButton.snp.height)
        }
    }
    
    func configureUI() {
        checkButton.setImage(
            UIImage(systemName: "checkmark.square")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(
            UIImage(systemName: "checkmark.square.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.setBackgroundColor(color: .white, forState: .normal)
        checkButton.setBackgroundColor(color: .white, forState: .selected)
        
        starButton.setImage(
            UIImage(systemName: "star")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
        starButton.setImage(
            UIImage(systemName: "star.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .selected)
        starButton.setBackgroundColor(color: .white, forState: .normal)
        starButton.setBackgroundColor(color: .white, forState: .selected)
    }
}
