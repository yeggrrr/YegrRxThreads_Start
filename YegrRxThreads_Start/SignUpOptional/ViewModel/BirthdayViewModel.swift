//
//  BirthdayViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    let validAgeText = Observable.just("만 17세 이상만 가입 가능합니다.")
    let nextButtonText = Observable.just("가입하기")
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let nextButtonTap: ControlEvent<Void>
        let nextButtonText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let year = BehaviorRelay(value: 2024)
        let month = BehaviorRelay(value: 8)
        let day = BehaviorRelay(value: 1)
        
        input.birthday
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)
                year.accept(component.year ?? 0)
                month.accept(component.month ?? 0)
                day.accept(component.day ?? 0)
            }
            .disposed(by: disposeBag)
        
        return Output(year: year,
                      month: month,
                      day: day,
                      nextButtonTap: input.nextButtonTap,
                      nextButtonText: nextButtonText)
    }
}
