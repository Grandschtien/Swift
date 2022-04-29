//
//  DayCell.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 03.04.2022.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textDateColor
        label.text = "28"
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textDateColor
        label.text = "Пн"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        if let isCellSelected = UserDefaults.standard.value(forKey: "isCellSelected") as? Bool, isCellSelected {
            setUnSelected()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        self.backgroundColor = .clear
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.pins(UIEdgeInsets(top: 7, left: 10, bottom: -7, right: -10))
        stackView.clipsToBounds = true
        stackView.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textDateColor?.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
    func configurate(day: String, date: String) {
        dateLabel.text = date
        dayLabel.text = day
    }
    func setSelected() {
        self.backgroundColor = .blueMain
        self.layer.borderColor = UIColor.blueMain?.cgColor
        self.dayLabel.textColor = .white
        self.dateLabel.textColor = .white
    }
    
    func setUnSelected() {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.textDateColor?.cgColor
        self.dayLabel.textColor = .textDateColor
        self.dateLabel.textColor = .textDateColor
    }
    
}
