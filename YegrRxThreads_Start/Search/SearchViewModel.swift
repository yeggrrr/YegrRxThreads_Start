//
//  SearchViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    private let searchBarPlaceholder = Observable.just("검색한 품목을 입력해주세요")
    
    var todo: [TodoModel] = []
    lazy var todoList = BehaviorSubject(value: todo)
    
    struct Input {
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let searchText: ControlProperty<String>
        let searchBarPlaceholder: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        return Output(searchText: input.searchText,
                      searchBarPlaceholder: searchBarPlaceholder)
    }
}
