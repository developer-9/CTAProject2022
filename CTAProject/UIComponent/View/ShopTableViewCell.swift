//
//  ShopTableViewCell.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/14.
//

import UIKit

final class ShopTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let shopImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Asset.shopSample.name)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let shopNameLabel: UILabel = {
        let label = UILabel()
        label.text = "馬肉食堂 BAKAYARO 本厚木"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "3001~4000円"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let shopDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "居酒屋/本厚木駅"
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
        stack.centerY(inView: self, leftAnchor: shopImageView.rightAnchor, paddingLeft: 20)
    }
}
