//
//  ShopTableViewCell.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/14.
//

import UIKit
import Kingfisher

final class ShopTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var listViewModel: ListViewModel? {
        didSet {
            populateShopData()
        }
    }
    
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
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        shopImageView.setDimensions(height: 80, width: 80)
        addSubview(shopImageView)
        shopImageView.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 20)
        
        let stack = UIStackView(arrangedSubviews: [shopNameLabel, budgetLabel, shopDetailLabel])
        stack.spacing = 8
        stack.distribution = .fill
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: shopImageView.rightAnchor, right: self.rightAnchor, paddingLeft: 20, paddingRight: 20)
    }
    
    private func populateShopData() {
        guard let listViewModel = listViewModel else { return }
        shopImageView.kf.setImage(with: listViewModel.logoImageUrl)
        shopNameLabel.text = listViewModel.shopName
        budgetLabel.text = listViewModel.budgetName
        shopDetailLabel.text = listViewModel.shopDetails
    }
}
