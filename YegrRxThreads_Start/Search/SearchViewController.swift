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
    
    let viewModel = SearchViewModel()
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
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.id)
    }
    
    func bind() {
        let input = SearchViewModel.Input(searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        viewModel.todoList
            .bind(to: tableView.rx.items(cellIdentifier: SearchCell.id, cellType: SearchCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let result = value.isEmpty ? owner.viewModel.todo :
                owner.viewModel.todo.filter { $0.title.contains(value)}
                owner.viewModel.todoList.onNext(result)
            }
            .disposed(by: disposeBag)
        
        output.searchBarPlaceholder
            .bind(with: self) { owner, value in
                owner.searchBar.placeholder = value
            }
            .disposed(by: disposeBag)
    }
}
