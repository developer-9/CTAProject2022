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
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(cellType: ShopTableViewCell.self)
    }
    
    private func configureUI() {
        tableView.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.fillSuperView()
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
