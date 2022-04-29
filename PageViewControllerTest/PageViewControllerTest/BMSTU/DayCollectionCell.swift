//
//  DayCell.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 03.04.2022.
//

import UIKit

class DayCollectionCell: UICollectionViewCell {
    typealias Day = DaysModel

    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    private var dateManager: DateManager = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let manager = DateManager(formatter: formatter, startDate: "02-06-2022", finishDate: "06-11-2022")
        return manager
    }()
    private lazy var header = HeaderOfCollection()
    private let numberOfItems: Int = 6
    private let insets: CGFloat = 15
    private var numberOFWeek: Int?
    private var previousIndex: IndexPath?
    var currWeek: Int?
    var week: Int?
    var currDay: (String, String)?
    
    private var dates = [Day]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dates = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollection()
    }
    required init?(coder: NSCoder) {
        fatalError("Fucking coder init")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupCollection() {
        header.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(header)
        self.contentView.addSubview(collectionView)
        header.top(7, isIncludeSafeArea: false)
        header.leading()
        header.trailing()
        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        collectionView.trailing()
        collectionView.leading()
        collectionView.bottom(isIncludeSafeArea: false)
        collectionView.register(DayCell.self)
        collectionView.isScrollEnabled = false
        self.contentView.backgroundColor = .mainBackground
        self.backgroundColor = .mainBackground
        collectionView.backgroundColor = .mainBackground
    }
    func configure(with week: Int, and days: [Day]) {
        header.configure(with: week)
        self.week = week
        dates = days
    }
}
extension DayCollectionCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: DayCell.self, for: indexPath)
        cell.configurate(day: dates[indexPath.item].daysAndDate.1, date: dates[indexPath.item].daysAndDate.0)
        currWeek! += 1
        if week == currWeek, currDay?.0 == dates[indexPath.item].daysAndDate.0, currDay?.1 ==  dates[indexPath.item].daysAndDate.1 {
            cell.setSelected()
            UserDefaults.standard.setValue(true, forKey: "isCellSelected")
            previousIndex = indexPath
        }
        return cell
    }
}
extension DayCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let prevIndex = previousIndex {
            guard let prevCell = collectionView.cellForItem(at: prevIndex) as? DayCell else { return }
            prevCell.setUnSelected()
            guard let cell = collectionView.cellForItem(at: indexPath) as? DayCell else { return }
            cell.setSelected()
            previousIndex = indexPath
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DayCell else { return }
            cell.setSelected()
            previousIndex = indexPath
        }
    }
    
}
extension DayCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
