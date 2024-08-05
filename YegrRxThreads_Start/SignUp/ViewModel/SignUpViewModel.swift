//
//  SignUpViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    let emailData = BehaviorSubject(value: "yegr@yegr.com")
    private let emailPlaceholder = Observable.just("이메일을 입력해주세요")
    private let nextButtonText = Observable.just("다음")
    private let validationButtonText = Observable.just("중복확인")
    
    struct Input {
        let text: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
        let validationTap: ControlEvent<Void>
    }
    
    struct Output {
        let textFieldValid: Observable<Bool>
        let nextButtonTap: ControlEvent<Void>
        let validationTap: ControlEvent<Void>
        let emailPlaceholder: Observable<String>
        let nextButtonText: Observable<String>
        let validationButtonText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.text.orEmpty
            .map { $0.count >= 4 }
            .share()
        
        return Output(textFieldValid: validation,
                      nextButtonTap: input.nextButtonTap,
                      validationTap: input.validationTap,
                      emailPlaceholder: emailPlaceholder,
                      nextButtonText: nextButtonText,
                      validationButtonText: validationButtonText
        )
    }
}
