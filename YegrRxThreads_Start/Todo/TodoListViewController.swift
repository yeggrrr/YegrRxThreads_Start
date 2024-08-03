//
//  TodoListViewController.swift
//  YegrRxThreads_Start
//
//  Created by YJ on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TodoListViewController: UIViewController {
    // MARK: Enum
    enum SectionType {
        case textField
        case items
    }
    
    // MARK: UI
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: Properties
    let sectionList: [SectionType] = [.textField, .items]
    let disposeBag = DisposeBag()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureUI()
    }
    
    // MARK: Functions
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(TodoTextFieldCell.self, forCellReuseIdentifier: TodoTextFieldCell.id)
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
    }
    
    func configureUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = "쇼핑"
    }
}

// MARK: UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionList[section] {
        case .textField:
            return 1
        case .items:
            return 10 // 임시
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionList[indexPath.section] {
        case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTextFieldCell.id, for: indexPath) as? TodoTextFieldCell else { return UITableViewCell() }
            cell.addButton.rx.tap
                .bind(with: self) { owner, _ in
                    print("추가 버튼 클릭됨")
                }
                .disposed(by: disposeBag)
            
            return cell
        case .items:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.id, for: indexPath) as? TodoListCell else { return UITableViewCell() }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension TodoListViewController: UITableViewDelegate { }
