//
//  BottomView.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 05/06/2023.
//

import UIKit
import SnapKit

class BottomView: UIView {
    let backButton = UIButton(type: .system)
    let forwardButton = UIButton(type: .system)
    let addFilterButton = UIButton(type: .system)
    let showFiltersButton = UIButton(type: .system)
    
    private let stackView = UIStackView()
    
    var buttons: [UIButton] {
        return [backButton, forwardButton, addFilterButton, showFiltersButton]
    }
    
    func layout(in view: UIView) {
        view.addSubview(self)
        setUpButtons()
        setUpStackView()
        
        layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor

        guard let safeAreaBottomInset = (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom else { return }
        let bottomViewHeight = safeAreaBottomInset > 0 ? 60 : 45
        
        snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(bottomViewHeight)
        }
    }
    
    private func setUpButtons() {
        backButton.setImage(UIImage(named: "chevron.left"), for: .normal)
        forwardButton.setImage(UIImage(named: "chevron.right"), for: .normal)
        addFilterButton.setImage(UIImage(named: "plus.app"), for: .normal)
        showFiltersButton.setImage(UIImage(named: "list.bullet.circle"), for: .normal)
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        buttons.forEach { button in
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .black
            button.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
    }
    
    private func setUpStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = stackView.frame.width / CGFloat(Double(buttons.count) * 1.5)
        stackView.distribution = .equalCentering
        stackView.alignment = .top
        buttons.forEach { button in
            stackView.addArrangedSubview(button)
        }
    }
}
