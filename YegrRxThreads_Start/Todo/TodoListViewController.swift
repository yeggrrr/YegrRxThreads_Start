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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureUI()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(TodoTextFieldCell.self, forCellReuseIdentifier: TodoTextFieldCell.id)
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.id)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "쇼핑"
        tableView.backgroundColor = .systemGray
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
            return cell
        case .items:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.id, for: indexPath) as? TodoListCell else { return UITableViewCell() }
            return cell
        }
    }
}

extension TodoListViewController: UITableViewDelegate { }
