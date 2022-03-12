//
//  ShopTableViewCell.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/14.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit
import Unio

final class ShopTableViewCell: UITableViewCell {

    // MARK: - Properties

    private let shopImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let shopNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let budgetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let shopDetailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()

    private var dependency: Dependency!
    private var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let viewStream = Dependency().viewStream
        configureUI()

        favoriteButton.rx.tap
            .subscribe(onNext: { _ in
                viewStream.input.favoriteButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)

        viewStream.output.favoriteState
            .withUnretained(self)
            .subscribe(onNext: { me, isFavorite in
                me.updateFavoriteUI(isFavorite: isFavorite)
            }).disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(favoriteButton)
    }

    // MARK: - Helpers

    private func updateFavoriteUI(isFavorite: Bool) {
        let systemName = isFavorite ? "star.fill" : "star"
        let tintColor = isFavorite ? UIColor.orange : UIColor.systemGray
        favoriteButton.setImage(UIImage(systemName: systemName), for: .normal)
        favoriteButton.tintColor = tintColor
    }

    private func configureUI() {
        shopImageView.setDimensions(height: 80, width: 80)
        addSubview(shopImageView)
        shopImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 20)

        let stack = UIStackView(arrangedSubviews: [shopNameLabel, budgetLabel, shopDetailLabel])
        stack.spacing = 8
        stack.distribution = .fill
        stack.axis = .vertical

        favoriteButton.setDimensions(height: 40, width: 40)
        addSubview(favoriteButton)
        favoriteButton.centerY(inView: self)
        favoriteButton.anchor(right: rightAnchor, paddingRight: 20)

        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: shopImageView.rightAnchor, right: favoriteButton.leftAnchor, paddingLeft: 20, paddingRight: 12)
    }

    func setupData(item: Shop) {
        shopImageView.kf.setImage(with: item.logoImage)
        shopNameLabel.text = item.name
        budgetLabel.text = item.budget.name
        shopDetailLabel.text = L10n.shopDetailText(item.genre?.name ?? "", item.stationName ?? "")
    }
}

// MARK: - Dependency Injection

extension ShopTableViewCell {
    struct Dependency {
        let viewStream: ListViewStreamType

        init(viewStream: ListViewStreamType = ListViewStream()) {
            self.viewStream = viewStream
        }
    }
}
