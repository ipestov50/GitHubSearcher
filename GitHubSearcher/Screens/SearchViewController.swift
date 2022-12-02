//
//  SearchViewController.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 23.11.2022.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entity)
        let sortDescriptor = NSSortDescriptor(key: Constants.sortName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
        return fetchedResultController
    }()
    
    let dataBaseStrategy = DataBaseStrategy()
    
    enum TableSelection: Int {
        case userList
        case loader
    }
    
    private let pageLimit = 30
    private var currentLastId: Int? = nil
    
    private var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search repository"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    var previousText: String?
    
    let tableView = UITableView()
    
    var repositories = [Repository]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        setupLayout()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(CustomTableViewCell.nib(), forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        RepositoryManager.shared.find(query: query) { [self] result in
            handleData(result: result, query: query)
            
        }
        if query.isEmpty {
            DispatchQueue.main.async { [self] in
                repositories.removeAll()
                tableView.reloadData()
            }
        }
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    func handleData(result: Result<[Repository], NetworkRequest.RequestError>, query: String?) {
        guard let query = query else { return }
        
        switch result {
        case .success(let data):
            if previousText == query {
                self.repositories.append(contentsOf: data)
                self.currentLastId = data.last?.id
            } else {
                previousText = query
                self.repositories.removeAll()
                self.repositories = data
            }
            print(data)
        case .failure(let error):
            print(error)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = TableSelection(rawValue: section) else { return 0 }
        switch listSection {
        case .userList:
            return repositories.count
        case .loader:
            return repositories.count >= pageLimit ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        guard let section = TableSelection(rawValue: indexPath.section) else { return UITableViewCell()}
        
        switch section {
        case .userList:
            let repository = repositories[indexPath.row]
            cell.textLabel?.text = repository.name
            cell.configure(state: repository)
        case .loader:
            cell.textLabel?.text = "Loading..."
            cell.textLabel?.textColor = .systemBlue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSelection(rawValue: indexPath.section) else { return }
        guard !repositories.isEmpty else { return }
        if section == .loader {
            print("load new data..")
            RepositoryManager.shared.find(query: searchController.searchBar.text!) { [self] result in
                DispatchQueue.main.async { [self] in
                    handleData(result: result, query: searchController.searchBar.text!)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = fetchResultController.object(at: indexPath) as! RepositoryEntity
        if let url = URL(string: repositories[indexPath.row].html_url!) {
            repositories[indexPath.row].isSeen = true
            UIApplication.shared.open(url)
        }
        repository.isSeen = repositories[indexPath.row].isSeen ?? false
        repository.name = repositories[indexPath.row].name
        CoreDataManager.instance.saveContext()
    }
}

extension SearchViewController {
    func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.repositories.count - 1, section: TableSelection.userList.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}
