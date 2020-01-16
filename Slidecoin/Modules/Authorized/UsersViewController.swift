//
//  UsersViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class UsersViewController: UIViewController {

    // MARK: Private Properties
    
    private let cellID = "\(UITableViewCell.self)"
    
    private let alertService = Assembly.alertService
    private let credentialsService = Assembly.credentialsService
    private let requestSender = Assembly.requestSender
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var users: [User] = []
    private var searchedUsers: [User] = []
    
    private var login: Login
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Lifecycle
    
    init(login: Login) {
        self.login = login
        
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupSearchController()
        
        obtainUsers()
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.title = "Пользователи"
        
        let deleteAllUsersButton = UIBarButtonItem(title: "Удалить всех", style: .done, target: self, action: #selector(allUsersDidDelete))
        navigationItem.rightBarButtonItem = deleteAllUsersButton
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func obtainUsers() {
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        let config = RequestFactory.users(accessToken: accessToken)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    switch error {
                    case is ResponseError:
                        let refreshConfig = RequestFactory.tokenRefresh(refreshToken: refreshToken)
                        self.requestSender.send(config: refreshConfig) { [weak self] result in
                            guard let self = self else { return }
                            
                            switch result {
                            case .success(let accessToken):
                                self.login.accessToken = accessToken
                                self.credentialsService.updateCredentials(with: self.login)
                                self.obtainUsers()
                                
                            case .failure(let error):
                                let alert = self.alertService.alert(error.localizedDescription)
                                self.present(alert, animated: true)
                            }
                        }
                        
                    default:
                        let alert = self.alertService.alert(error.localizedDescription)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    private func filterContent(for searchText: String) {
        searchedUsers = users.filter {
            $0.username.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @objc private func allUsersDidDelete() {
        let message = "Вы действительно хотите удалить всех пользователей \"Сладовалюты\"?"
        let alert = alertService.alert(message,
                                       title: "Внимание",
                                       isDestructive: true) { [weak self] _ in
            self?.deleteAll()
        }
        
        self.present(alert, animated: true)
    }
    
    private func deleteAll() {
        let config = RequestFactory.deleteAllUsers()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let login):
                    let alert = self.alertService.alert(login.message,
                                                        title: "Сообщение",
                                                        isDestructive: false) { [weak self] _ in
                        self?.reset()
                    }
                
                    self.present(alert, animated: true)
                    
                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func reset() {
        credentialsService.removeCredentials()
        
        let scene = UIApplication.shared.connectedScenes.first
        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
            let vc = AuthViewController()
            let nvc = UINavigationController(rootViewController: vc)
            mySceneDelegate.window?.rootViewController = nvc
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
        let user = searchController.isActive ? searchedUsers[indexPath.row] : users[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
    }
}




// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransferViewController()
        let nvc = UINavigationController(rootViewController: vc)
        
        present(nvc, animated: true)
        
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
