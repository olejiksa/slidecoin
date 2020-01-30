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
    
    private let cellID = "\(UserCell.self)"
    
    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    private let currentUser: User
    private var users: [User] = []
    private var searchedUsers: [User] = []
    private var login: Login
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Lifecycle
    
    init(login: Login, currentUser: User) {
        self.login = login
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupRefreshControl()
        setupSearchController()
        
        obtainUsers()
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.title = "Пользователи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if currentUser.isAdmin == 1 {
            let deleteAllUsersButton = UIBarButtonItem(title: "Удалить всех", style: .plain, target: self, action: #selector(allUsersDidDelete))
            navigationItem.rightBarButtonItem = deleteAllUsersButton
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = 60
        tableView.register(UINib(nibName: cellID, bundle: .main), forCellReuseIdentifier: cellID)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
        
        if users.isEmpty {
            spinner.startAnimating()
        }
        
        let config = RequestFactory.users(accessToken: accessToken)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.spinner.stopAnimating()
                    self.tableView.separatorStyle = .singleLine
                    self.refreshControl.endRefreshing()
                    self.users = users.sorted(by: { $0.balance > $1.balance })
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
                                self.userDefaultsService.updateLogin(with: self.login)
                                self.refreshControl.beginRefreshing()
                                self.obtainUsers()
                                
                            case .failure(let error):
                                self.spinner.stopAnimating()
                                self.tableView.separatorStyle = .singleLine
                                self.refreshControl.endRefreshing()
                                let alert = self.alertService.alert(error.localizedDescription)
                                self.present(alert, animated: true)
                            }
                        }
                        
                    default:
                        self.spinner.stopAnimating()
                        self.tableView.separatorStyle = .singleLine
                        self.refreshControl.endRefreshing()
                        let alert = self.alertService.alert(error.localizedDescription)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    private func filterContent(for searchText: String) {
        searchedUsers = users.filter {
            $0.username.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText) ||
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.surname.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @objc private func allUsersDidDelete() {
        let message = "Вы действительно хотите удалить всех пользователей \"Сладовалюты\"?"
        let alert = alertService.alert(message,
                                       title: .attention,
                                       isDestructive: true) { [weak self] _ in
            self?.deleteAll()
        }
        
        self.present(alert, animated: true)
    }
    
    @objc private func refresh() {
        obtainUsers()
    }
    
    private func deleteAll() {
        let config = RequestFactory.deleteAllUsers()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let login):
                    let alert = self.alertService.alert(login.message,
                                                        title: .attention,
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
        userDefaultsService.removeCredentials()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserCell
        let user = searchController.isActive ? searchedUsers[indexPath.row] : users[indexPath.row]
        cell?.setup(user: user)
        return cell ?? UITableViewCell(frame: .zero)
    }
}




// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        let user = searchController.isActive ? searchedUsers[indexPath.row] : users[indexPath.row]
        
        let vc = UserViewController(user: user,
                                    currentUser: currentUser,
                                    accessToken: accessToken,
                                    refreshToken: refreshToken,
                                    isCurrent: user.id == currentUser.id)
        
        if let splitVc = splitViewController, !splitVc.isCollapsed {
            let nvc = UINavigationController(rootViewController: vc)
            splitVc.showDetailViewController(nvc, sender: self)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
        
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




// MARK: - UISplitViewControllerDelegate

extension UsersViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
