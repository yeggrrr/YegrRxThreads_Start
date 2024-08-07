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
    
    var recomendList = ["맥북", "키보드", "아이폰", "커피머신", "운동화", "머그컵", "아이폰 케이스", "이어폰"]
    
    struct Input {
        let addButtonTap: ControlEvent<Void>
        let tableViewItemSelected: ControlEvent<IndexPath>
        let tableViewItemDeleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        let todoList: Observable<[TodoModel]>
        let addButtonTap: ControlEvent<Void>
        let tableViewItemSelected: ControlEvent<IndexPath>
        let tableViewItemDeleted: ControlEvent<IndexPath>
        let recomendList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        let recomendList = BehaviorSubject(value: recomendList)
        
        return Output(todoList: todoList,
                      addButtonTap: input.addButtonTap,
                      tableViewItemSelected: input.tableViewItemSelected,
                      tableViewItemDeleted: input.tableViewItemDeleted,
                      recomendList: recomendList
        )
    }
}
