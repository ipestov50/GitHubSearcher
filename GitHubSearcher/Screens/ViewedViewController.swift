//
//  ViewedViewController.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 29.11.2022.
//

import UIKit
import CoreData

class ViewedViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellName)
        tableView.delegate = self
        tableView.dataSource = self
        fetchedResultController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func deleteItems() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RepositoryEntity")
        do {
            let results = try CoreDataManager.instance.context.fetch(fetchRequest)
            for result in results as! [RepositoryEntity] {
                CoreDataManager.instance.context.delete(result)
            }
        } catch {
            print(error)
        }
        CoreDataManager.instance.saveContext()
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
}

extension ViewedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath)
        let repository = fetchedResultController.object(at: indexPath) as! RepositoryEntity
        cell.textLabel?.text = repository.name
        return cell
    }
    
}

extension ViewedViewController: NSFetchedResultsControllerDelegate {
    // Информируем о начали изменения данных
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let repository = fetchedResultController.object(at: indexPath) as! RepositoryEntity
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = repository.name
            }
        default:
            break
        }
    }
    
    // Информируем об окончании изменения данных
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
