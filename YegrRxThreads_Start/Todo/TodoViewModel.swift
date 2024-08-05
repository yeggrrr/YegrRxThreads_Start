//
//  TodoViewModel.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TodoViewModel {   
    var todo: [TodoModel] = [
        TodoModel(check: false, title: "임시값1", star: false),
        TodoModel(check: false, title: "임시값2", star: false)
    ]
    
    lazy var todoList = BehaviorSubject(value: todo)
    
    struct Input {
        let addButtonTap: ControlEvent<Void>
        let tableViewItemSelected: ControlEvent<IndexPath>
        let tableViewItemDeleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        let addButtonTap: ControlEvent<Void>
        let tableViewItemSelected: ControlEvent<IndexPath>
        let tableViewItemDeleted: ControlEvent<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(addButtonTap: input.addButtonTap,
                      tableViewItemSelected: input.tableViewItemSelected,
                      tableViewItemDeleted: input.tableViewItemDeleted
        )
    }
}
