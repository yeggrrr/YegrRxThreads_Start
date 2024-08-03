//
//  TodoTextFieldCell.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/3/24.
//

import UIKit
import SnapKit

class TodoTextFieldCell: UITableViewCell, ViewRepresentable {
    let horizontalStackView = UIStackView()
    let textField = UITextField()
    let addButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews([textField, addButton])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalTo(safeArea).inset(10)
        }
        
        addButton.snp.makeConstraints {
            $0.width.equalTo(60)
        }
    }
    
    func configureUI() {
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        
        addButton.addUI(title: "추가")
        textField.placeholder = "구매하실 품목을 입력해주세요."
    }
}
