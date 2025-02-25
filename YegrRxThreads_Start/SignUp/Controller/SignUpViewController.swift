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

    private let basicColor = Observable.just(UIColor.systemGreen)
    
    private let viewModel = SignUpViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        let input = SignUpViewModel.Input(text: emailTextField.rx.text,
                                          nextButtonTap: nextButton.rx.tap,
                                          validationTap: validationButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        basicColor.bind(
            to:nextButton.rx.backgroundColor,
            emailTextField.rx.textColor,
            emailTextField.rx.tintColor)
        .disposed(by: disposeBag)
        
        basicColor.map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.emailData
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.textFieldValid
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.textFieldValid
            .bind(with: self) { owner, value in
            let color: UIColor = value ? .systemGreen : .systemRed
            owner.nextButton.backgroundColor = color
            owner.validationButton.isHidden = !value
        }
        .disposed(by: disposeBag)
        
        output.emailPlaceholder
            .bind(with: self) { owner, value in
                owner.emailTextField.placeholder = value
            }
            .disposed(by: disposeBag)
        
        output.validationButtonText
            .bind(with: self) { owner, value in
                owner.validationButton.setTitle(value, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.validationTap
            .bind(with: self) { owner, _ in
                owner.viewModel.emailData.onNext("sesac@sesac.com")
            }
            .disposed(by: disposeBag)
        
        output.nextButtonText
            .bind(with: self) { owner, value in
                owner.nextButton.setTitle(value, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func addSubviews() {
        view.addSubviews([emailTextField, validationButton, nextButton])
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
        
        emailTextField.setUI()
        nextButton.setUI()
        validationButton.setTitleColor(.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = UIColor.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
}
