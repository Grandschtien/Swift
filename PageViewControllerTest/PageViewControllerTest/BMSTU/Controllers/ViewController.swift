//
//  ViewController.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 27.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var navigationBar = MainCustomNavigationBar(with: "ИУ8-84",
                                                             and: UIImage(named: "QR") ?? UIImage(),
                                                             frame: .zero)
    private lazy var segmentControl = CustomSegementControl(frame: .zero,
                                                            buttonTitles: titlesInSegment)
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
        return pageVC
    }()
    
    
    private lazy var  myContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainBackground
        return view
    }()
    
    private let titlesInSegment = ["Расписание", "Личный кабинет"]
    private let viewControllers: [UIViewController]
    private var currentPage: Int = 0
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("fucking init with coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .mainBackground
        segmentControl.delegate = self
        segmentControl.textColor = .white
        segmentControl.selectorTextColor = .white
        segmentControl.selectorViewColor = .blueMain ?? .blue
        segmentControl.backgroundColor = .segementColor
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        view.addSubview(segmentControl)
        view.addSubview(myContainerView)
        
        navigationBar.heightAnchor.constraint(equalToConstant: 57).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 37).isActive = true
        segmentControl.topAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                            constant: 26).isActive = true
        NSLayoutConstraint.activate([
            myContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            myContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            myContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            myContainerView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10)
        ])
        addChild(pageViewController)
        
        // we need to re-size the page view controller's view to fit our container view
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // add the page VC's view to our container view
        myContainerView.addSubview(pageViewController.view)
        
        // constrain it to all 4 sides
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: myContainerView.topAnchor, constant: 0.0),
            pageViewController.view.bottomAnchor.constraint(equalTo: myContainerView.bottomAnchor, constant: 0.0),
            pageViewController.view.leadingAnchor.constraint(equalTo: myContainerView.leadingAnchor, constant: 0.0),
            pageViewController.view.trailingAnchor.constraint(equalTo: myContainerView.trailingAnchor, constant: 0.0),
        ])
        
        pageViewController.didMove(toParent: self)
    }
}
//MARK: - It wil implement in second pageViewController
extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return nil }

        guard viewControllers.count > previousIndex else { return nil }

        return viewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < viewControllers.count else { return nil }

        guard viewControllers.count > nextIndex else { return nil }

        return viewControllers[nextIndex]
    }
    
    
}

extension ViewController: CustomSegementControlDelegate {
    func changeToIndex(index: Int) {
        if currentPage > index {
            pageViewController.setViewControllers([viewControllers[index]], direction: .reverse, animated: true)

        } else {
            pageViewController.setViewControllers([viewControllers[index]], direction: .forward, animated: true)
        }
        currentPage = index
    }
}

/*
 Nowadays there are so many professions you can apply to.
 But, in my opinion, the most interesting and well-paid ones are in the IT field.
 So my future profession will be related to IT.
 However, in IT, too, a lot of professions.
 You can do analytics, backend development, databases, etc.
 However, out of all of these I chose IOS development.
 This area of IT is actively developing and I like it very much.
 It combines both technical aspects and creativity and design.
 Now, oddly enough, there is a shortage of IOS developers, so it is also a profitable profession.
 This deficit is due to the fact that the entry threshold into this profession is quite high.
 */

