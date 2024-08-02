//
//  SignInViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController, ViewRepresentable {
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signInButton = UIButton()
    private let signUpButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func addSubviews() {
        view.addSubviews([emailTextField, passwordTextField, signInButton, signUpButton])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(safeArea).offset(200)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        signInButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(signInButton.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        emailTextField.setUI(placeholderText: "이메일을 입력해주세요")
        passwordTextField.setUI(placeholderText: "비밀번호를 입력해주세요")
        signInButton.setUI(title: "로그인")
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
    }
}

