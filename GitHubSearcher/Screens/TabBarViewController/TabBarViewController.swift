//
//  TabBarViewController.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 23.11.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConotroller()
        setupTabBar()
    }
    
    func setupViewConotroller() {
        viewControllers = [
            createNavigationController(for: SearchViewController(), title: "", image: UIImage(systemName: "magnifyingglass")!),
            createNavigationController(for: ViewedViewController(), title: "History", image: UIImage(systemName: "eye.circle")!),
        ]
    }
    
    func setupTabBar() {
        view.backgroundColor = .white
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }
    
    fileprivate func createNavigationController(for rootViewController: UIViewController,
                                                     title: String,
                                                     image: UIImage) -> UIViewController {
           let navigationController = UINavigationController(rootViewController: rootViewController)
           navigationController.tabBarItem.title = title
           navigationController.tabBarItem.image = image
           navigationController.navigationBar.prefersLargeTitles = true
           rootViewController.navigationItem.title = title
           return navigationController
       }
    
}
