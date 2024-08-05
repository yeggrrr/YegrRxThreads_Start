//
//  NicknameViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel {
    let textFieldPlaceholder = Observable.just("닉네임을 입력해주세요")
    let nextButtonText = Observable.just("다음")
    
    struct Input {
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let nextButtonTap: ControlEvent<Void>
        let textFieldPlaceholder: Observable<String>
        let nextButtonText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(nextButtonTap: input.nextButtonTap,
                      textFieldPlaceholder: textFieldPlaceholder,
                      nextButtonText: nextButtonText)
    }
}
