//
//  ViewController.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import UIKit
import SnapKit

private enum Const {
    static let shimmersCount = 8
    static let stackHeight: CGFloat = 38
}

protocol ITodoListView: IBaseView {
    
    func showAlert(with error: IAppError)
    func reloadData()
    func reloadRow(at indexPath: IndexPath)
    func insertRow(at indexPath: IndexPath)
}

final class TodoListVC: UIViewController {
    
    // Dependencies
    private let alertManager = AlertManager()
    private let presenter: ITodoListPresenter
    
    // UI
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var refreshControl: RefreshControl = {
        let view = RefreshControl()
        view.addAction { [weak self] in
            self?.presenter.pullToRefresh()
        }
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseID)
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    private lazy var footerView = ButtonFooterView()

    // MARK: - Initialization
    
    init(_ presenter: ITodoListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupNavigationBar()
        setupSearchController()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(footerView)
        footerView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        configFooterView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(footerView.snp.top)
        }
    }
    
    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск задачи"
        searchController.searchBar.tintColor = .systemBlue
        definesPresentationContext = true
    }
    
    private func configFooterView() {
        footerView.config(with: ButtonFooterView.Model(infoText: pluralizeTasks(presenter.filteredTodos.count),
                                                       rightButtonIcon: UIImage(systemName: "square.and.pencil"),
                                                       rightButtonAction: presenter.newTodoButtonDidTap))
    }
    
    private func updateFooterView() {
        footerView.update(with: presenter.isLoading ? "" : pluralizeTasks(presenter.filteredTodos.count))
    }
    
    private func pluralizeTasks(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) задача"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "\(count) задачи"
        } else {
            return "\(count) задач"
        }
    }
}

// MARK: - IWeatherView

extension TodoListVC: ITodoListView {
    
    func showAlert(with error: IAppError) {
        alertManager.show(error)
    }
    
    func reloadData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
        updateFooterView()
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func insertRow(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateFooterView()
    }
}

// MARK: - UISearchResultsUpdating

extension TodoListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        presenter.searchTextChanged(searchText)
    }
}

// MARK: - UITableViewDataSource

extension TodoListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.isLoading ? Const.shimmersCount : presenter.filteredTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoCell = tableView.reusableCell(indexPath: indexPath)
        if !presenter.isLoading {
            cell.config(with: presenter.filteredTodos[indexPath.row])
        } else {
            cell.configForShimmer()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TodoListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.todoDidTap(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(presenter.isLoading, viewBackgroundColor: .lightGray)
    }
}
