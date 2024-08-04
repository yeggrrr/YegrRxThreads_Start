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
        TodoModel(check: false, title: "임시값", star: false),
        TodoModel(check: true, title: "임시값2", star: true)
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
        todoList
            .bind(to: tableView.rx.items(cellIdentifier: TodoListCell.id, cellType: TodoListCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.checkButton.isSelected = element.check
                cell.starButton.isSelected = element.star
                cell.checkButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("버튼을 클릭했어요")
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.navigationController?.pushViewController(DetailViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
