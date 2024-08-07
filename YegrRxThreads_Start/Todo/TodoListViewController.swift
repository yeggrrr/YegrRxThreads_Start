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
    private let topView = UIView()
    private let horizontalStackView = UIStackView()
    private let textField = UITextField()
    private let addButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout())
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: Properties
    private let sectionList: [SectionType] = [.textField, .items]
    
    let viewModel = TodoViewModel()
    private let disposeBag = DisposeBag()

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
        view.addSubviews([topView, collectionView, tableView])
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea).inset(10)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
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
        
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: RecommendCell.id)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        
        addButton.addUI(title: "추가")
        textField.placeholder = "구매하실 품목을 입력해주세요."
    }
    
    private func bind() {
        let input = TodoViewModel.Input(addButtonTap: addButton.rx.tap,
                                        tableViewItemSelected: tableView.rx.itemSelected,
                                        tableViewItemDeleted: tableView.rx.itemDeleted
        )
        
        let output = viewModel.transform(input: input)
        
        // tableView
        output.todoList
            .bind(to: tableView.rx.items(cellIdentifier: TodoListCell.id, cellType: TodoListCell.self)) { (row, element, cell) in
                cell.configureCell(row: row, element: element, viewModel: self.viewModel)
            }
            .disposed(by: disposeBag)
        
        output.tableViewItemSelected
            .bind(with: self) { owner, indexPath in
                owner.editAction(row: indexPath.row)
            }
            .disposed(by: disposeBag)
        
        output.tableViewItemDeleted
            .bind(with: self) { owner, indexPath in
                owner.viewModel.todo.remove(at: indexPath.row)
                owner.viewModel.todoList.onNext(owner.viewModel.todo)
            }
            .disposed(by: disposeBag)
        
        output.addButtonTap
            .withLatestFrom(textField.rx.text.orEmpty) { void, text in
                return text
            }
            .bind(with: self) { owner, value in
                owner.viewModel.todo.insert(TodoModel(check: false, title: value, star: false), at: 0)
                owner.viewModel.todoList.onNext(owner.viewModel.todo)
                owner.textField.text = ""
            }
            .disposed(by: disposeBag)
        
        // collectionView
        output.recomendList
            .bind(to: collectionView.rx.items(cellIdentifier: RecommendCell.id, cellType: RecommendCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(String.self)
            .subscribe(with: self) { owner, value in
                owner.viewModel.todo.insert(TodoModel(check: false, title: value, star: false), at: 0)
                owner.viewModel.todoList.onNext(owner.viewModel.todo)
            }
            .disposed(by: disposeBag)
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SearchViewController()
                vc.viewModel.todo = owner.viewModel.todo
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        return UIBarButtonItem(customView: button)
    }
    
    private func editAction(row: Int) {
        let oldTodo = viewModel.todo[row]
        
        let alert = UIAlertController(title: "리스트 수정하기", message: "내용을 입력하세요.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let editButton = UIAlertAction(title: "수정", style: .default) { _ in
            guard
                let firstTextField = alert.textFields?[0],
                let newTitle = firstTextField.text
            else { return }
            
            let newTodo = TodoModel(check: oldTodo.check, title: newTitle, star: oldTodo.star)
            self.viewModel.todo[row] = newTodo
            self.viewModel.todoList.onNext(self.viewModel.todo)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(editButton)
        alert.addTextField { textField in
            textField.placeholder = "입력해주세요."
            textField.text = oldTodo.title
        }
        
        self.present(alert, animated: true)
    }
    
    static func collectionViewlayout() ->  UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 30)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        return layout
    }
}
