//
//  SignUpViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    let emailData = BehaviorSubject(value: "yegr@yegr.com")
    
    struct Input {
        let text: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
        let validationTap: ControlEvent<Void>
    }
    
    struct Output {
        let textFieldValid: Observable<Bool>
        let nextButtonTap: ControlEvent<Void>
        let validationTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.text.orEmpty
            .map { $0.count >= 4 }
        
        return Output(textFieldValid: validation,
                      nextButtonTap: input.nextButtonTap,
                      validationTap: input.validationTap
        )
    }
}
