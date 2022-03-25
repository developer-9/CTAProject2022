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

    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: L10n.favoriteImage), for: .normal)
        button.tintColor = .systemGray
        button.tag = 1
        return button
    }()

    private (set) var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(favoriteButton)
    } 

    // MARK: - Helpers

    func updateFavoriteUI() {
        if favoriteButton.tag == 0 {
            favoriteButton.setImage(UIImage(systemName: L10n.favoriteImageFill), for: .normal)
            favoriteButton.tintColor = .orange
            favoriteButton.tag = 1
        } else {
            favoriteButton.setImage(UIImage(systemName: L10n.favoriteImage), for: .normal)
            favoriteButton.tintColor = .systemGray
            favoriteButton.tag = 0
        }
    }
    
    private func CheckFavorite(item: Shop) {
        let objectId = RealmRepository().getArray(type: FavoriteShop.self).map { $0.id }
        if objectId.contains(item.id) {
            favoriteButton.setImage(UIImage(systemName: L10n.favoriteImageFill), for: .normal)
            favoriteButton.tintColor = .orange
            favoriteButton.tag = 1
        } else {
            favoriteButton.setImage(UIImage(systemName: L10n.favoriteImage), for: .normal)
            favoriteButton.tintColor = .systemGray
            favoriteButton.tag = 0
        }
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
  
    func setupSearchData(item: Shop) {
        shopImageView.kf.setImage(with: item.logoImage)
        shopNameLabel.text = item.name
        budgetLabel.text = item.budget.name
        shopDetailLabel.text = L10n.shopDetailText(item.genre?.name ?? "", item.stationName ?? "")
        
        CheckFavorite(item: item)
    }

    func setupFavoriteData(item: FavoriteShop) {
        shopImageView.kf.setImage(with: URL(string: item.logoImage))
        shopNameLabel.text = item.name
        budgetLabel.text = item.budget
        shopDetailLabel.text = L10n.shopDetailText(item.genre, item.station)
        favoriteButton.setImage(UIImage(systemName: L10n.favoriteImageFill), for: .normal)
        favoriteButton.tintColor = .orange
    }
}
