//
//  ListViewController.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/12.
//

import UIKit
import PKHUD

final class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let repository: SearchRepository
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private lazy var alertView: AlertView = {
        let view = AlertView()
        view.delegate = self
        return view
    }()
    
    private var shops = [Shop]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init(repository: SearchRepository = SearchRepositoryImpl()) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar(withTitle: L10n.navigationBarTitle)
        configureSearchController()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func searchShops(with keyword: String) {
        HUD.show(.progress)
        repository.searchShops(with: keyword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let shopResponse):
                self.shops = shopResponse.results.shop
            case .failure(let error):
                print("DEBUG: Error \(error.description)")
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
    }
    
    private func configureSearchController() {
        searchBar.placeholder = L10n.searchBarPlaceholder
        searchBar.backgroundColor = UIColor.CTA.searchBarBackground
        searchBar.delegate = self
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(cellType: ShopTableViewCell.self)
    }
    
    private func configureUI() {
        tableView.backgroundColor = .systemGray6
                
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 80)
        
        view.addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    private func characterLimit(searchText: String) -> String {
        let characterLimit = 50
        let validCharacters = String(searchText.prefix(characterLimit))
        return validCharacters
    }
}

// MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.count > 50 {
            view.addSubview(alertView)
            alertView.fillSuperView()
            searchBar.text = characterLimit(searchText: searchText)
        } else {
            searchShops(with: searchText)
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ShopTableViewCell.self)
        cell.listViewModel = ListViewModel(shop: shops[indexPath.row])
        return cell
    }
}

// MARK: - AlertViewDelegate

extension ListViewController: AlertViewDelegate {
    func handleDsimiss() {
        alertView.removeFromSuperview()
    }
}
