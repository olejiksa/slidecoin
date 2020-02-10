//
//  TransactionsViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class TransactionsViewController: UIViewController {

    private let alertService = Assembly.alertService
    private let requestSender = Assembly.requestSender
    private let userDefaultsService = Assembly.userDefaultsService
    private let cellID = "\(TransactionCell.self)"
    
    private let user: User
    
    private let refreshControl = UIRefreshControl()
    private var isFilterEnabled = false
    
    private var userIDs: [Int: String] = [:]
    private var transactions: [[Transaction]] = []
    private var filteredTransactions: [[Transaction]] = []
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    init(user: User) {
        self.user = user
        
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
        
        obtainTransactions(filter: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Транзакции"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        if user.isAdmin {
            let filterIcon = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(filter))
        }
    }
    
    private func setupTableView() {
        tableView.register(TransactionCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func obtainTransactions(filter: Bool) {
        if transactions.isEmpty {
            spinner.startAnimating()
        }
        
        let config = RequestFactory.transactions()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    let usersConfig = RequestFactory.users()
                    self.requestSender.send(config: usersConfig) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let users):
                            for i in 0..<users.count {
                                self.userIDs[users[i].id] = users[i].username
                            }
                            
                            self.spinner.stopAnimating()
                            self.tableView.separatorStyle = .singleLine
                            self.refreshControl.endRefreshing()
                            self.transactions = self.dated(transactions: transactions.reversed())
                            self.tableView.reloadData()
                            
                            if filter {
                                self.filter()
                            }
                            
                        case .failure(let error):
                            self.spinner.stopAnimating()
                            self.tableView.separatorStyle = .singleLine
                            self.refreshControl.endRefreshing()
                            let alert = self.alertService.alert(error.localizedDescription)
                            self.present(alert, animated: true)
                        }
                    }
                    
                case .failure(let error):
                    switch error {
                    case is ResponseError:
                        let refreshConfig = RequestFactory.tokenRefresh()
                        self.requestSender.send(config: refreshConfig) { [weak self] result in
                            guard let self = self else { return }
                            
                            switch result {
                            case .success(let accessToken):
                                Global.accessToken = accessToken
                                
                                let login = Login(refreshToken: Global.refreshToken,
                                                  accessToken: accessToken, message: "")
                                self.userDefaultsService.updateLogin(with: login)
                                self.refreshControl.beginRefreshing()
                                self.obtainTransactions(filter: filter)
                                
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
    
    @objc private func refresh() {
        obtainTransactions(filter: false)
    }
    
    @objc private func filter() {
        isFilterEnabled = !isFilterEnabled
        
        let iconName = "line.horizontal.3.decrease.circle"
        let icon = isFilterEnabled ? UIImage(systemName: "\(iconName).fill") : UIImage(systemName: iconName)
        navigationItem.rightBarButtonItem?.image = icon
        
        filteredTransactions = dated(transactions: transactions.joined().filter { $0.senderID == user.id || $0.receiverID == user.id })
        tableView.reloadData()
    }
    
    private func dated(transactions: [Transaction]) -> [[Transaction]] {
        let dict = Dictionary(grouping: transactions, by: { transaction -> Date in
            let components = Calendar.current.dateComponents([.day, .month, .year], from: transaction.date)
            return Calendar.current.date(from: components)!
        })
        
        var array = [[Transaction]]()
        for (_, value) in dict {
            array.append(value)
        }
        
        array.sort(by: { $0.first!.date > $1.first!.date })
        
        return array
    }
}




// MARK: - UITableViewDataSource

extension TransactionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return !isFilterEnabled ? transactions.count : filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let transaction = transactions[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        // let offsetTime = TimeInterval(TimeZone.current.secondsFromGMT())
        // let date = transaction.first!.date.addingTimeInterval(offsetTime)
        return dateFormatter.string(from: transaction.first!.date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !isFilterEnabled ? transactions[section].count : filteredTransactions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? TransactionCell
        let transaction = !isFilterEnabled ? transactions[indexPath.section][indexPath.row] : filteredTransactions[indexPath.section][indexPath.row]
        cell?.setup(transaction: transaction, userIDs: userIDs, user: user)
        return cell ?? UITableViewCell(frame: .zero)
    }
}




// MARK: - UITableViewDelegate

extension TransactionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = !isFilterEnabled ? transactions[indexPath.section][indexPath.row] : filteredTransactions[indexPath.section][indexPath.row]
        let sender = userIDs[transaction.senderID]
        let receiver = userIDs[transaction.receiverID]
        
        let vc = TransactionViewController(transaction: transaction, senderName: sender, receiverName: receiver)
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
