//
//  UsersViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class UsersViewController: UIViewController {

    private let cellID = "\(UITableViewCell.self)"
    private let alertService: AlertServiceProtocol = AlertService()
    private let requestSender: RequestSenderProtocol = RequestSender()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var users: [User] = []
    private var searchedUsers: [User] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Пользователи"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        let config = RequestFactory.users()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func filterContent(for searchText: String) {
        searchedUsers = users.filter {
            $0.username.localizedCaseInsensitiveContains(searchText)
        }
    }
}




// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchedUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = searchController.isActive ? searchedUsers[indexPath.row].username : users[indexPath.row].username
        return cell
    }
}




// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




// MARK: - UISearchResultsUpdating

extension UsersViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContent(for: searchText)
        tableView.reloadData()
    }
}
