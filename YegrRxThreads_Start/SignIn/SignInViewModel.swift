//
//  SignInViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel {
    private let emailPlaceholder = Observable.just("이메일을 입력해주세요")
    private let passwordPlaceholder = Observable.just("비밀번호를 입력해주세요")
    private let signInButtonText = Observable.just("로그인")
    private let signUpButtonText = Observable.just("회원이 아니십니까?")
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let emailPlaceholder: Observable<String>
        let passwordPlaceholder: Observable<String>
        let signInButtonText: Observable<String>
        let signUpButtonText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        return Output(tap: input.tap,
                      emailPlaceholder: emailPlaceholder,
                      passwordPlaceholder: passwordPlaceholder,
                      signInButtonText: signInButtonText,
                      signUpButtonText: signUpButtonText)
    }
}
