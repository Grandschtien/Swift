//
//  DaysHeaderView.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 06.04.2022.
//

import UIKit

class DaysHeaderView: UICollectionReusableView {
    private lazy var horizontalCollection: HorisontalCollectionView = HorisontalCollectionView(frame: .zero)
    typealias Day = DaysModel
    
    //var datesWithDays = [(String, String)]()
    var datesWithDays = [Day]()
    private var currentItem = 0
    private var previousIndexPath: IndexPath?
    private var startIndex = 0
    var currWeek: Int?
    var currDay: (String, String)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .mainBackground
        horizontalCollection.backgroundColor = .mainBackground
        horizontalCollection.dataSource = self
        horizontalCollection.delegate = self
        horizontalCollection.collectionView.register(DayCollectionCell.self)
        self.addSubview(horizontalCollection)
        horizontalCollection.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollection.top(isIncludeSafeArea: false)
        horizontalCollection.leading()
        horizontalCollection.trailing()
        horizontalCollection.heightAnchor.constraint(equalToConstant: 95).isActive = true
        setupRecognizers()
    }
    
    private func setupRecognizers() {
        let rightSwipeRec = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction(_:)))
        rightSwipeRec.direction = .right
        
        let leftSwipeRec = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction(_:)))
        leftSwipeRec.direction = .left
        
        horizontalCollection.addGestureRecognizer(rightSwipeRec)
        horizontalCollection.addGestureRecognizer(leftSwipeRec)
        horizontalCollection.resignFirstResponder()
        
    }
    @objc
    func rightSwipeAction(_ sender: UISwipeGestureRecognizer) {
        if currentItem > 0 {
            currentItem -= 1
            horizontalCollection.collectionView.scrollToItem(at: IndexPath(item: currentItem, section: 0),
                                                             at: .centeredHorizontally,
                                                             animated: true)
        }
    }
    @objc
    func leftSwipeAction(_ sender: UISwipeGestureRecognizer) {
        if currentItem < 17 {
            currentItem += 1
            horizontalCollection.collectionView.scrollToItem(at: IndexPath(item: currentItem, section: 0),
                                                             at: .centeredHorizontally,
                                                             animated: true)
        }
    }
}

extension DaysHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return datesWithDays.count / 6
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: DayCollectionCell.self, for: indexPath)
        var currentDays = [Day]()
        currentDays.removeAll()
        let currWeek = indexPath.item + 1
        let currIndex = indexPath.item
        if let prevIndexPath = previousIndexPath {
            if prevIndexPath > indexPath {
                startIndex -= 6
            } else {
                startIndex += 6
            }
        }
        let startIndex = currIndex * 6
        let finishedIndex = startIndex + 6
        print(startIndex, finishedIndex - 1)
        for index in startIndex..<finishedIndex {
            currentDays.append(datesWithDays[index])
        }
        cell.configure(with: currWeek, and: currentDays)
        previousIndexPath = indexPath
        cell.currWeek = currWeek
        cell.currDay = currDay
        return cell
    }
}
extension DaysHeaderView: HorisontalCollectionViewDelegate {
    func calculateSectionInset() -> CGFloat {
        return 18
    }
}
