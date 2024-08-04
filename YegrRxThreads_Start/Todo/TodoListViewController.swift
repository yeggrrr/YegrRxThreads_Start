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

final class TodoListViewController: UIViewController, ViewRepresentable {
    // MARK: Enum
    enum SectionType {
        case textField
        case items
    }
    
    // MARK: UI
    let topView = UIView()
    let horizontalStackView = UIStackView()
    let textField = UITextField()
    let addButton = UIButton()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: Properties
    let sectionList: [SectionType] = [.textField, .items]
    var todo: [TodoModel] = [
        TodoModel(check: false, title: "임시값1", star: false),
        TodoModel(check: false, title: "임시값2", star: false)
    ]
    lazy var todoList = BehaviorSubject(value: todo)
    
    let disposeBag = DisposeBag()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        bind()
    }
    
    // MARK: Functions
    func addSubviews() {
        view.addSubviews([topView, tableView])
        topView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews([textField, addButton])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        topView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(10)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(55)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalTo(topView.snp.edges).inset(10)
        }
        
        addButton.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalTo(safeArea).inset(10)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = "쇼핑"
        
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        
        topView.backgroundColor = .white
        topView.layer.cornerRadius = 10
        
        tableView.backgroundColor = .systemGray6
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.id)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        
        addButton.addUI(title: "추가")
        textField.placeholder = "구매하실 품목을 입력해주세요."
    }
    
    func bind() {
        navigationItem.rightBarButtonItem?.target = self
        
        todoList
            .bind(to: tableView.rx.items(cellIdentifier: TodoListCell.id, cellType: TodoListCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                cell.titleLabel.text = element.title
                cell.checkButton.isSelected = element.check
                cell.starButton.isSelected = element.star
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.checkButton.isSelected.toggle()
                        guard let title = cell.titleLabel.text else { return }
                        let newTodo = TodoModel(check: cell.checkButton.isSelected, title: title, star: cell.starButton.isSelected)
                        self.todo[row] = newTodo
                        self.todoList.onNext(self.todo)
                    }
                    .disposed(by: cell.disposeBag)
                cell.starButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.starButton.isSelected.toggle()
                        guard let title = cell.titleLabel.text else { return }
                        let newTodo = TodoModel(check: cell.checkButton.isSelected, title: title, star: cell.starButton.isSelected)
                        self.todo[row] = newTodo
                        self.todoList.onNext(self.todo)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                self.editAction(row: indexPath.row)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.todo.remove(at: indexPath.row)
                owner.todoList.onNext(owner.todo)
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty) { void, text in
                return text
            }
            .bind(with: self) { owner, value in
                owner.todo.insert(TodoModel(check: false, title: value, star: false), at: 0)
                owner.todoList.onNext(owner.todo)
                owner.textField.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SearchViewController()
                vc.todo = self.todo
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        return UIBarButtonItem(customView: button)
    }
    
    func editAction(row: Int) {
        let oldTodo = todo[row]
        
        let alert = UIAlertController(title: "리스트 수정하기", message: "내용을 입력하세요.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let editButton = UIAlertAction(title: "수정", style: .default) { alertAction in
            guard
                let firstTextField = alert.textFields?[0],
                let newTitle = firstTextField.text
            else { return }
            
            let newTodo = TodoModel(check: oldTodo.check, title: newTitle, star: oldTodo.star)
            self.todo[row] = newTodo
            self.todoList.onNext(self.todo)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(editButton)
        alert.addTextField { textField in
            textField.placeholder = "입력해주세요."
            textField.text = oldTodo.title
        }
        
        self.present(alert, animated: true)
    }
}
