//
//  SignInViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(tap: input.tap)
    }
}
