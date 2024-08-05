//
//  PhoneViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: UIViewController, ViewRepresentable {
    private let phoneTextField = UITextField()
    private let nextButton = UIButton()
    
    private let viewModel = PhoneViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        let input = PhoneViewModel.Input(nextButtonTap: nextButton.rx.tap,
                                         textFieldValidText: phoneTextField.rx.text)
        let output = viewModel.transform(input: input)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.initialNumberText.bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .systemGray
            owner.nextButton.backgroundColor = color
            owner.nextButton.isEnabled = value
        }
        .disposed(by: disposeBag)
        
        output.textFieldPlaceholder
            .bind(with: self) { owner, value in
                owner.phoneTextField.placeholder = value
            }
            .disposed(by: disposeBag)
        
        output.nextButtonText
            .bind(with: self) { owner, value in
                owner.nextButton.setTitle(value, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    func addSubviews() {
        view.addSubviews([phoneTextField, nextButton])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        phoneTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(safeArea).offset(200)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(phoneTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        phoneTextField.setUI()
        phoneTextField.keyboardType = .numberPad
        nextButton.setUI()
    }
}
