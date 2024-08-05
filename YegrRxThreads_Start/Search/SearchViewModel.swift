//
//  SearchViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    var todo: [TodoModel] = []
    lazy var todoList = BehaviorSubject(value: todo)
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
