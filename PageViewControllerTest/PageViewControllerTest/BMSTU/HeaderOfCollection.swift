//
//  HeaderOfCollection.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 03.04.2022.
//

import UIKit

class HeaderOfCollection: UIView {
    private lazy var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .mainBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    private lazy var header: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(contentView)
        contentView.pins()
        contentView.addSubview(header)
        header.pins()
    }
    
    func configure(with week: Int) {
        var resultText = "\(week) неделя,"
        if week % 2 != 0 {
            resultText += " числитель"
        } else {
            resultText += " знаменатель"
        }
        header.text = resultText
    }
}
