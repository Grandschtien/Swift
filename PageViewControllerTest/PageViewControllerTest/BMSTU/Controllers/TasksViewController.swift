//
//  TasksViewController.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 30.03.2022.
//

import UIKit



class TasksViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    typealias Day = DaysModel
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Day>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Day>
    
    
    private lazy var mainCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .mainBackground
        collection.delegate = self
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    private var header: NSCollectionLayoutBoundarySupplementaryItem?
    private lazy var datesWithDays: [Day] = setupDates()
    private lazy var dataSource = makeDataSource()
    private var offset: CGFloat = 0
    private var dateManager: DateManager = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let manager = DateManager(formatter: formatter, startDate: "02-06-2022", finishDate: "06-11-2022")
        return manager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applySnapshot()
    }
    
    private func setupDates() -> [Day]{
        let datesWithDays = dateManager.datesWithDays()
        var result = [Day]()
        for value in datesWithDays {
            let day = Day(daysAndDate: value)
            result.append(day)
        }
        return result
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: mainCollectionView,
            cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in
                let cell = collectionView.dequeueCell(cellType: TimetableCell.self, for: indexPath)
                return cell
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            // 2
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            // 3
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DaysHeaderView.reuseIdentifier,
                for: indexPath) as? DaysHeaderView
            header?.currWeek = self.dateManager.getCurrentWeek()
            header?.currDay = self.dateManager.getCurrDayAndDate()
            header?.datesWithDays = self.datesWithDays
            return header
        }
        return dataSource
    }
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.datesWithDays, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupUI() {
        view.addSubview(mainCollectionView)
        mainCollectionView.pins()
        mainCollectionView.register(DaysHeaderView.self,
                                    forSupplementaryViewOfKind:
                                        UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: DaysHeaderView.reuseIdentifier)
        mainCollectionView.register(TimetableCell.self)
    }
    
    private func createLayout() -> UICollectionViewLayout {
       // let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]) // <---
        group.contentInsets = NSDirectionalEdgeInsets(top: 45, leading: 11, bottom: 0, trailing: 11)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        header?.pinToVisibleBounds = true
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [header!]
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }

}

extension TasksViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let offsetDirection = offset > 0

        if offsetDirection {
            header?.pinToVisibleBounds = true
        } else {
            header?.pinToVisibleBounds = false
        }
        self.mainCollectionView.collectionViewLayout.invalidateLayout()
    }
}

