//
//  PhoneViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    let initialNumberText = Observable.just("010")
    private let textFieldPlaceholder = Observable.just("연락처를 입력해주세요")
    private let nextButtonText = Observable.just("다음")
    
    struct Input {
        let nextButtonTap: ControlEvent<Void>
        let textFieldValidText: ControlProperty<String?>
    }
    
    struct Output {
        let nextButtonTap: ControlEvent<Void>
        let validation: Observable<Bool>
        let textFieldPlaceholder: Observable<String>
        let nextButtonText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.textFieldValidText.orEmpty
            .map { $0.count >= 10 && Int($0) != nil }
        
        return Output(nextButtonTap: input.nextButtonTap,
                      validation: validation,
                      textFieldPlaceholder: textFieldPlaceholder,
                      nextButtonText: nextButtonText)
    }
}
