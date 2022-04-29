//
//  MainCustomNavigationBar.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 30.03.2022.
//

import UIKit

class MainCustomNavigationBar: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        return button
    }()
    private lazy var bottomBorder: CALayer = {
       let border = CALayer()
        border.backgroundColor = UIColor.borderInNavigationColor?.cgColor
        return border
    }()
    
    
    private let image: UIImage
    private let text: String
    var action: (() -> Void)?
    
    init(with text: String, and image: UIImage, frame: CGRect) {
        self.text = text
        self.image = image
        super.init(frame: frame)
        commonInit()
    }
    
    override init(frame: CGRect) {
        self.text = ""
        self.image = UIImage()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func commonInit() {
        self.addSubview(label)
        self.addSubview(button)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 21).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                         constant: -16).isActive = true
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 11).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(x: 0,
                              y: self.frame.size.height - 1.0,
                              width: self.frame.size.width,
                              height: 1.0)
        self.layer.addSublayer(bottomBorder)
    }
    
    @objc
    private func buttonTapped() {
        action?()
    }
}
