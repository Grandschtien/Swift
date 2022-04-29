//
//  TimetabletableCell.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 06.04.2022.
//

import UIKit

class TimetabletableCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        self.backgroundColor = .mainBackground
        self.layer.cornerRadius = 10
        containerView.layer.cornerRadius = 10
        self.contentView.backgroundColor = .mainBackground
        containerView.backgroundColor = UIColor(red: 0.173, green: 0.173, blue: 0.176, alpha: 1)
    }
}
