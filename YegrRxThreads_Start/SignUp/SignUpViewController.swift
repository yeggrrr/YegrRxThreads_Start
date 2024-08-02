//
//  SignUpViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum YegrError: Error {
    case invalidEmail
}

final class SignUpViewController: UIViewController, ViewRepresentable {
    private let emailTextField = UITextField()
    private let validationButton = UIButton()
    private let nextButton = UIButton()
    
    private let emailData = BehaviorSubject(value: "yegr@yegr.com")
    private let basicColor = Observable.just(UIColor.systemGreen)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        // color
        basicColor.bind(
            to:nextButton.rx.backgroundColor,
            emailTextField.rx.textColor,
            emailTextField.rx.tintColor)
        .disposed(by: disposeBag)
        
        basicColor.map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        // emailData
        emailData
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        // textField
        let textFieldValid = emailTextField.rx.text.orEmpty
            .map { $0.count >= 4 }
        
        textFieldValid.bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        textFieldValid.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemGreen : .systemRed
            owner.nextButton.backgroundColor = color
            owner.validationButton.isHidden = !value
        }
        .disposed(by: disposeBag)
        
        // button
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.emailData.onNext("sesac@sesac.com")
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func addSubviews() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        validationButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(safeArea).offset(200)
            $0.trailing.equalTo(safeArea).inset(20)
            $0.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(safeArea).offset(200)
            $0.leading.equalTo(safeArea).inset(20)
            $0.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        emailTextField.setUI(placeholderText: "이메일을 입력해주세요")
        nextButton.setUI(title: "다음")
        
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = UIColor.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
}
