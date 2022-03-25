//
//  FavoriteViewController.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/12.
//

import RealmSwift
import RxCocoa
import RxDataSources
import RxRealm
import RxSwift
import UIKit
import PKHUD

final class FavoriteViewController: UIViewController {

    // MARK: - Properties

    private let viewStream: FavoriteViewStreamType

    private let tableView = UITableView()
    private var dataSource: RxTableViewSectionedReloadDataSource<FavoriteShopDataSource>?

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(viewStream: FavoriteViewStreamType = FavoriteViewStream()) {
        self.viewStream = viewStream
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(withTitle: L10n.navigationBarTitle)
        configureTableView()
        
        guard let dataSource = dataSource else { return }
        viewStream.output.dataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewStream.output.hud
            .subscribe(onNext: { type in
                HUD.show(type)
            }).disposed(by: disposeBag)
        
        viewStream.output.hide
            .subscribe(onNext: { _ in
                HUD.hide()
            }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewStream.input.load.onNext(())
    }

    // MARK: - Helpers

    private func configureTableView() { 
        tableView.backgroundColor = .systemGray6
        view.addSubview(tableView)
        tableView.fillSuperView()

        tableView.rowHeight = Const.TableView.height
        tableView.register(cellType: ShopTableViewCell.self)

        dataSource =
            RxTableViewSectionedReloadDataSource<FavoriteShopDataSource>(configureCell: { [weak self] _, tableView, indexPath, item in
                guard let me = self else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ShopTableViewCell.self)
                cell.setupFavoriteData(item: item)
                
                cell.favoriteButton.rx.tap
                    .subscribe(onNext: { _ in
                        me.viewStream.input.deleteFavorite.onNext(item.id)
                    }).disposed(by: cell.disposeBag)
                return cell
            })
    }
}

// MARK: - Private Const

extension FavoriteViewController {
    private enum Const {
        enum TableView {
            static let height = CGFloat(100)
        }
    }
}
