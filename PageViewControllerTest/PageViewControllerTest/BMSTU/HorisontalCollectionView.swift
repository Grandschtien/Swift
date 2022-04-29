//
//  HorisontalCollectionView.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 03.04.2022.
//

import UIKit

protocol HorisontalCollectionViewDelegate: AnyObject {
    func calculateSectionInset() -> CGFloat
}

class HorisontalCollectionView: UIView {

    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        collection.isScrollEnabled = false
        collection.backgroundColor = .mainBackground
        return collection
    }()
    
    var action: (() -> Void)?
    weak var dataSource: UICollectionViewDataSource? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }
    weak var delegate: HorisontalCollectionViewDelegate?
    
    private var indexOfCellBeforeDragging = 0
    private let defaultSectionInsets: CGFloat = 100
    private let defaultSizeOfCell: CGSize = CGSize(width: 50, height: 50)
    private let minimumLineSpacing: CGFloat = 20
    private let minimumInteritemSpacing: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCollectionViewLayoutSize()
    }
    
    private func configureCollectionView() {
        self.backgroundColor = .mainBackground
        collectionView.backgroundColor = .mainBackground
        self.addSubview(collectionView)
        collectionView.pins()
    }
    
    private func configureCollectionViewLayoutSize() {
        let inset: CGFloat = delegate?.calculateSectionInset() ?? defaultSectionInsets
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0,
                                                             left: inset,
                                                             bottom: 0,
                                                             right: inset)
        collectionViewFlowLayout.itemSize = CGSize (
            width: (collectionView.collectionViewLayout.collectionView?.frame.size.width ?? 0) - inset * 2,
            height: collectionView.collectionViewLayout.collectionView?.frame.size.height ?? 0
        )
    }
}
extension HorisontalCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {}

