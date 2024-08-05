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
    
    let year = BehaviorRelay(value: 2024)
    let month = BehaviorRelay(value: 8)
    let day = BehaviorRelay(value: 1)
    
    var differenceDay = BehaviorSubject(value: 0)
    
    let validAgeText = Observable.just("만 17세 이상만 가입 가능합니다.")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    func bind() {
        birthDayPicker.rx.date.bind(with: self) { owner, date in
            let component = Calendar.current.dateComponents([.day, .month, .year], from: date)
            owner.year.accept(component.year ?? 0)
            owner.month.accept(component.month ?? 0)
            owner.day.accept(component.day ?? 0)
        }
        .disposed(by: disposeBag)
  
        year.map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month.map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day.map { "\($0)일 "}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        validAgeText.bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        year.bind { year in
            self.changeText(year: year, month: self.month.value, day: self.day.value)
        }
        .disposed(by: disposeBag)
        
        month.bind { month in
            self.changeText(year: self.year.value, month: month, day: self.day.value)
        }
        .disposed(by: disposeBag)

        day.bind { day in
            self.changeText(year: self.year.value, month: self.month.value, day: day)
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap
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
        
        // birthDayPicker
        birthDayPicker.setUI()
        
        // containerStackView
        containerStackView.setUI()
        
        // labels
        [yearLabel, monthLabel, dayLabel].forEach {
            $0.textAlignment = .center
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18, weight: .regular)
        }
        
        // nextButton
        nextButton.setTitle("가입하기", for: .normal)
        nextButton.setUI()
    }
}
