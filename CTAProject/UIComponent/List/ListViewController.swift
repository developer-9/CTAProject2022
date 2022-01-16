//
//  ListViewController.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/12.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar(withTitle: L10n.navigationBarTitle)
        configureUI()
    }
    
    // MARK: - Helpers
    
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ShopTableViewCell.self)
        return cell
    }
}
