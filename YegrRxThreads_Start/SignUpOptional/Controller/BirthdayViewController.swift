//
//  BirthdayViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthdayViewController: UIViewController, ViewRepresentable {
    let birthDayPicker = UIDatePicker()
    let infoLabel = UILabel()
    let containerStackView = UIStackView()
    let yearLabel = UILabel()
    let monthLabel = UILabel()
    let dayLabel = UILabel()
    let nextButton = UIButton()
    
    var differenceDay = BehaviorSubject(value: 0)
    
    let viewModel = BirthdayViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    func bind() {
        let input = BirthdayViewModel.Input(birthday: birthDayPicker.rx.date,
                                            nextButtonTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        viewModel.validAgeText.bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
  
        output.year.map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month.map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.day.map { "\($0)일 "}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.year.bind { year in
            self.changeText(year: year, month: output.month.value, day: output.day.value)
        }
        .disposed(by: disposeBag)
        
        output.month.bind { month in
            self.changeText(year: output.year.value, month: month, day: output.day.value)
        }
        .disposed(by: disposeBag)

        output.day.bind { day in
            self.changeText(year: output.year.value, month: output.month.value, day: day)
        }
        .disposed(by: disposeBag)
        
        output.nextButtonText
            .bind(with: self) { owner, value in
                owner.nextButton.setTitle(value, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "가입이 완료되었습니다!", okText: "확인") {
                    owner.navigationController?.pushViewController(TodoListViewController(), animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func changeText(year: Int, month: Int, day: Int) {
        if getDifferenceDays(year: year, month: month, day: day) {
            infoLabel.rx.text
                .onNext("가입이 가능한 나이입니다")
            infoLabel.rx.textColor
                .onNext(.systemBlue)
            nextButton.rx.backgroundColor
                .onNext(.systemBlue)
            nextButton.rx.isEnabled
                .onNext(true)
        } else {
            infoLabel.rx.text
                .onNext("만 17세 이상만 가입이 가능합니다")
            infoLabel.rx.textColor
                .onNext(.systemRed)
            nextButton.rx.backgroundColor
                .onNext(.lightGray)
            nextButton.rx.isEnabled
                .onNext(false)
        }
    }
    
    func addSubviews() {
        view.addSubviews([infoLabel, containerStackView, birthDayPicker, nextButton])
        containerStackView.addArrangedSubviews([yearLabel, monthLabel, dayLabel])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(80)
            }
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        // navigaion
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        birthDayPicker.setUI()
        containerStackView.setUI()
        nextButton.setUI()
        
        [yearLabel, monthLabel, dayLabel].forEach {
            $0.textAlignment = .center
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18, weight: .regular)
        }
    }
}
