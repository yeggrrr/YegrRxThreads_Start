//
//  PasswordViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: UIViewController, ViewRepresentable {
    private let passwordTextField = UITextField()
    private let nextButton = UIButton()
    private let descriptionLabel = UILabel()
    
    private let descriptionText = Observable.just("8자 이상 입력해주세요")
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        descriptionText.bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        
        validation.bind(with: self) { owner, value in
            owner.descriptionLabel.isHidden = value
        }
        .disposed(by: disposeBag)
        
        validation.bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .systemGray
            owner.nextButton.backgroundColor = color
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func addSubviews() {
        view.addSubviews([passwordTextField, nextButton, descriptionLabel])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(safeArea).offset(200)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        passwordTextField.setUI(placeholderText: "비밀번호를 입력해주세요")
        nextButton.setUI(title: "다음")
    }
}
