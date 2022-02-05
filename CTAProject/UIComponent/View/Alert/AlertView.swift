//
//  AlertView.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/20.
//

import UIKit
import RxSwift
import RxCocoa

final class AlertView: UIView {
    
    // MARK: - Properties
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.characterAlertMesssage
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.CTA.baseYellow
        button.setTitle(L10n.closeButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        
        closeButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
        }.disposed(by: disposeBag)
            guard let me = self else { return }
            me.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.setDimensions(height: frame.height / 4, width: frame.width - 40)
        closeButton.setDimensions(height: frame.height / 16, width: frame.width / 3)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        addSubview(containerView)
        containerView.center(inView: self)
        
        containerView.addSubview(messageLabel)
        messageLabel.center(inView: containerView)
        messageLabel.anchor(left: containerView.leftAnchor, right: containerView.rightAnchor,
                            paddingLeft: 10, paddingRight: 10)

        containerView.addSubview(closeButton)
        closeButton.centerX(inView: containerView)
        closeButton.anchor(bottom: containerView.bottomAnchor)
    }
}
