//
//  PasswordViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    let descriptionText = Observable.just("8자 이상 입력해주세요")
    let passwordValidText = Observable.just("비밀번호를 입력해주세요")
    let nextButtonText = Observable.just("다음")
    
    struct Input {
        let passwordText: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let passwordValidation: Observable<Bool>
        let nextButtonTap: ControlEvent<Void>
        let passwordValidText: Observable<String>
        let nextButtonText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.passwordText.orEmpty
            .map { $0.count >= 8 }
        
        return Output(passwordValidation: validation,
                      nextButtonTap: input.nextButtonTap,
                      passwordValidText: passwordValidText,
                      nextButtonText: nextButtonText
        )
    }
}
