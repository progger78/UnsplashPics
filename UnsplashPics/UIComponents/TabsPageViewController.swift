//
//  TabsPageViewController.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import Tabman
import Pageboy
import UIKit

import UIKit

class TabsPageViewController: UIViewController {
    
    private lazy var tabBar: UISegmentedControl = {
        
        let control = UISegmentedControl(items: [firstTabTitle, secondTabTitle])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeTab(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
  
    var firstTabTitle: String = ""
    var secondTabTitle: String = ""
    
    var firstTabVC: UIViewController?
    var secondTabVC: UIViewController?
    
    private lazy var viewControllers: [UIViewController] = {
        guard let firstTabVC, let secondTabVC else { return [] }
        
        return [firstTabVC, secondTabVC]
    }()
    
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        pageViewController.setViewControllers([viewControllers[currentIndex]], direction: .forward, animated: false)
    }
    
    func updateTitles(firstTab: String?, secondTab: String?) {
        guard let firstTab, let secondTab else { return }
        
        firstTabTitle = firstTab
        secondTabTitle = secondTab

        tabBar.removeAllSegments()
        tabBar.insertSegment(withTitle: firstTab, at: 0, animated: false)
        tabBar.insertSegment(withTitle: secondTab, at: 1, animated: false)
        tabBar.selectedSegmentIndex = 0
    }

    
    private func setupUI() {
        view.addSubview(tabBar)
        view.addSubview(pageViewController.view)
        
        tabBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabBar.snp.bottom).offset(8)
        }
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    @objc private func didChangeTab(_ sender: UISegmentedControl) {
        let newIndex = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = newIndex > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([viewControllers[newIndex]], direction: direction, animated: true)
        currentIndex = newIndex
    }
}

// MARK: - UIPageViewControllerDataSource
extension TabsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index < viewControllers.count - 1 
        else {
            return nil
        }
        return viewControllers[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension TabsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: currentVC) {
            tabBar.selectedSegmentIndex = index
            currentIndex = index
        }
    }
}
