//
//  ListViewController.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/12.
//

import PKHUD
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class ListViewController: UIViewController {

    // MARK: - Properties

    private let tableView = UITableView()
    private let searchBar = UISearchBar()

    private let viewModel: ListViewModelType
    private var dataSource: RxTableViewSectionedReloadDataSource<ShopResponseSectionModel>?

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(viewModel: ListViewModelType = ListViewModel()) {
        self.viewModel = viewModel
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

        // MARK: Inputs

        searchBar.searchTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(to: viewModel.inputs.searchText)
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(to: viewModel.inputs.searchButtonClicked)
            .disposed(by: disposeBag)

        // MARK: Outputs

        viewModel.outputs.validatedText
            .bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.alert
            .observe(on: ConcurrentMainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { me, _ in
                me.view.endEditing(true)
                let alertView = AlertView()
                me.view.addSubview(alertView)
                alertView.fillSuperView()
            }).disposed(by: disposeBag)

        viewModel.outputs.hud
            .subscribe(onNext: { type in
                HUD.show(type)
            }).disposed(by: disposeBag)

        viewModel.outputs.hide
            .subscribe(onNext: { _ in
                HUD.hide()
            }).disposed(by: disposeBag)

        guard let dataSource = dataSource else { return }
        viewModel.outputs.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers

    private func configureSearchController() {
        searchBar.placeholder = L10n.searchBarPlaceholder
        searchBar.backgroundColor = UIColor.CTA.searchBarBackground
    }

    private func configureTableView() {
        tableView.rowHeight = Const.TableView.height
        tableView.register(cellType: ShopTableViewCell.self)

        dataSource =
            RxTableViewSectionedReloadDataSource<ShopResponseSectionModel>(configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ShopTableViewCell.self)
                cell.setupData(item: item)
                return cell
            })
    }

    private func configureUI() {
        tableView.backgroundColor = .systemGray6

        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: Const.SearchBar.height)

        view.addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

// MARK: - Private Const

extension ListViewController {
    private enum Const {
        enum SearchBar {
            static let height = CGFloat(80)
        }
        enum TableView {
            static let height = CGFloat(100)
        }
    }
}
