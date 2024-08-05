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
    
    private let viewModel = PasswordViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        let input = PasswordViewModel.Input(passwordText: passwordTextField.rx.text,
                                            nextButtonTap: nextButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        viewModel.descriptionText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        output.passwordValidation
            .bind(with: self) { owner, value in
            owner.descriptionLabel.isHidden = value
        }
        .disposed(by: disposeBag)
        
        
        output.passwordValidation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.passwordValidation
            .bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .systemGray
            owner.nextButton.backgroundColor = color
        }
        .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.passwordValidText
            .bind(with: self) { owner, value in
                owner.passwordTextField.setUI(placeholderText: value)
            }
            .disposed(by: disposeBag)
        
        output.nextButtonText
            .bind(with: self) { owner, value in
                owner.nextButton.setUI(title: value)
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
    }
}
