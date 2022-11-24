//
//  SearchViewController.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 23.11.2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    private var repositories = [Repository]()

    private var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search repository"
        searchController.searchBar.searchBarStyle = . minimal
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        RepositoryManager.shared.find(query: query, page: 30) { repo in
            print(repo)
        }
        
    }

}
