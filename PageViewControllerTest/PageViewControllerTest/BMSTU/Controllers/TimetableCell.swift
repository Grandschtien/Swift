//
//  TimetableCell.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 06.04.2022.
//

import UIKit

protocol TimetableCellDelegate: AnyObject {
    func tableDidScroll(to frame: CGRect)
}

class TimetableCell: UICollectionViewCell {
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .mainBackground
        table.isScrollEnabled = false
        table.separatorStyle = .none
        return table
    }()
    weak var delegate: TimetableCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.backgroundColor = .mainBackground
        self.contentView.addSubview(tableView)
        tableView.pins()
        tableView.register(UINib(nibName: TimetabletableCell.nibName, bundle: nil), forCellReuseIdentifier: TimetabletableCell.reuseIdentifier)
        
    }
}
extension TimetableCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cellType: TimetabletableCell.self, for: indexPath)
        return cell
    }
    
}

extension TimetableCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
