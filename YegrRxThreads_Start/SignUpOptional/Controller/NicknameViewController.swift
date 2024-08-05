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
    
    private let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    private func bind() {
        let input = NicknameViewModel.Input(nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.textFieldPlaceholder
            .bind(with: self) { owner, value in
                owner.nicknameTextField.placeholder = value
            }
            .disposed(by: disposeBag)
        
        output.nextButtonText
            .bind(with: self) { owner, value in
                owner.nextButton.setTitle(value, for: .normal)
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
        nicknameTextField.setUI()
        nextButton.setUI()
    }
}
