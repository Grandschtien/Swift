//
//  WeekView.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 28.03.2022.
//

import UIKit

class WeekView: UIView {
    
    private var countOfViews: Int = 0
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    lazy var customView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var views = [UIView]()
    
    init(frame: CGRect, countOfViews: Int) {
        self.countOfViews = countOfViews
        super.init(frame: frame)
        setup(count: countOfViews)

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(count: Int) {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        var tag = 0
        
        for _ in 0..<countOfViews {
            let custom = CustomView(frame: .zero)
            views.append(custom)
            stackView.addArrangedSubview(custom)
            let rec = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
            custom.layer.borderColor = UIColor.black.cgColor
            custom.layer.borderWidth = 1
            custom.translatesAutoresizingMaskIntoConstraints = false
            custom.heightAnchor.constraint(equalToConstant: 50).isActive = true
            custom.widthAnchor.constraint(equalToConstant: 50).isActive = true
            custom.layer.cornerRadius = 25
            custom.tag = tag
            custom.addGestureRecognizer(rec)
            custom.isUserInteractionEnabled = true
            custom.clipsToBounds = true
            tag += 1
        }
    }
    
    @objc
    func tapped(_ sender: UITapGestureRecognizer) {
        for (_, custom) in views.enumerated() {
            if sender.view?.tag == custom.tag {
                if let customView = custom as? CustomView, customView.countOfTapps % 2 != 0 {
                    custom.backgroundColor = .white
                    customView.countOfTapps += 1
                } else {
                    for view in views {
                        if view.backgroundColor == .blue {
                            view.backgroundColor = .white
                        }
                    }
                    if let customView = custom as? CustomView {
                        customView.countOfTapps += 1
                    }
                    custom.backgroundColor = .blue
                }
            }
        }
    }
}
