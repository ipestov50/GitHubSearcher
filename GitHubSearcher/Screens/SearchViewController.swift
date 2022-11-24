//
//  SearchViewController.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 23.11.2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }

}
