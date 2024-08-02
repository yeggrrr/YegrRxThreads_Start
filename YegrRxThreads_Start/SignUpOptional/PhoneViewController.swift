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
    let phoneTextField = UITextField()
    let nextButton = UIButton()
    
    let initialNumberText = Observable.just("010")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        initialNumberText.bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        let validation = phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 && Int($0) != nil }
        
        validation.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .systemGray
            owner.nextButton.backgroundColor = color
            owner.nextButton.isEnabled = value
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
        
        phoneTextField.setUI(placeholderText: "연락처를 입력해주세요")
        phoneTextField.keyboardType = .numberPad
        nextButton.setUI(title: "다음")
    }
}
