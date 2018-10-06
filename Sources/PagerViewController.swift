//
//  PagerViewController.swift
//  Pager
//
//  Created by Matteo Battistini on 15/02/2018.
//

import UIKit

class PagerViewController: UIPageViewController {
    
    var pages: [UIViewController] = []
    var currentIndex: Event<Int> = Event(0)
    
    var currentViewController: UIViewController? {
        get {
            return self.viewControllers?.first
        }
    }
    
    init(pages: [UIViewController], transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        self.pages = pages
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
    }
    
    internal func show(index: Int) {
        guard index < self.pages.count else { return }
        let vc = self.pages[index]
        let direction: UIPageViewControllerNavigationDirection = (index > currentIndex.value) ? .forward : .reverse
        currentIndex.value = index
        setViewControllers([vc], direction: direction , animated: true, completion: nil)
    }
    
}


extension PagerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("will start transition to \(pages.index(of: pendingViewControllers.first!)!)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = self.currentViewController {
            currentIndex.value = self.pages.index(of: currentViewController) ?? 0
            print("did appear \(currentIndex.value)")
        }
    }

    

}

extension PagerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count, pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
    
}
