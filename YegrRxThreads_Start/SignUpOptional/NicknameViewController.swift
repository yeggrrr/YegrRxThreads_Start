//
//  NicknameViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameViewController: UIViewController, ViewRepresentable {
    private let nicknameTextField = UITextField()
    private let nextButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func addSubviews() {
        view.addSubviews([nicknameTextField, nextButton])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(safeArea).offset(200)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        nicknameTextField.setUI(placeholderText: "닉네임을 입력해주세요")
        nextButton.setUI(title: "다음")
    }
}
