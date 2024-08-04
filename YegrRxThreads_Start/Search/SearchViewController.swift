//
//  SearchViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController, ViewRepresentable {
    let searchBar = UISearchBar()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var todo: [TodoModel] = []
    lazy var todoList = BehaviorSubject(value: todo)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    func addSubviews() {
        view.addSubviews([searchBar, tableView])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "검색"
        searchBar.placeholder = "검색한 품목을 입력해주세요"
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
    }
    
    func bind() {
        todoList
            .bind(to: tableView.rx.items(cellIdentifier: SearchCell.id, cellType: SearchCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                cell.titleLabel.text = element.title
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let result = value.isEmpty ? owner.todo :
                owner.todo.filter { $0.title.contains(value)}
                owner.todoList.onNext(result)
            }
            .disposed(by: disposeBag)
    }
}
