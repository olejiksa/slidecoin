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
    private let cellID = "\(SubtitleCell.self)"
    private let user: User
    private let accessToken: String
    
    private let refreshControl = UIRefreshControl()
    private var isFilterEnabled = false
    
    private var transactions: [Transaction] = []
    private var filteredTransactions: [Transaction] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    init(user: User, accessToken: String) {
        self.user = user
        self.accessToken = accessToken
        
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
        
        obtainTransactions()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Транзакции"
        navigationItem.largeTitleDisplayMode = .never
        
        let filterIcon = UIImage(systemName: "line.horizontal.3.decrease.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filter))
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func setupTableView() {
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func obtainTransactions() {
        let config = RequestFactory.transactions(accessToken: accessToken)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    self.transactions = transactions.reversed()
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func refresh() {
        obtainTransactions()
    }
    
    @objc private func filter() {
        isFilterEnabled = !isFilterEnabled
        
        let iconName = "line.horizontal.3.decrease.circle"
        let icon = isFilterEnabled ? UIImage(systemName: "\(iconName).fill") : UIImage(systemName: iconName)
        navigationItem.rightBarButtonItem?.image = icon
        
        filteredTransactions = transactions.filter { $0.senderID == user.id || $0.receiverID == user.id }
        tableView.reloadData()
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
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        return dateFormatter.string(from: transaction.date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SubtitleCell
        let transaction = !isFilterEnabled ? transactions[indexPath.section] : filteredTransactions[indexPath.section]
        cell?.textLabel?.text = "\(transaction.amount) ₿"
        
        let condition = transaction.amount < 0 || user.id == transaction.senderID || transaction.receiverID == 0
        cell?.textLabel?.textColor = condition ? UIColor.systemRed : UIColor.systemGreen
        
        switch user.id {
        case transaction.receiverID:
            cell?.detailTextLabel?.text = "Пополнение (от кого): \(transaction.senderID)"
            
        case transaction.senderID:
            cell?.detailTextLabel?.text = "Перевод (кому): \(transaction.receiverID)"
            
        default:
            cell?.detailTextLabel?.text = "От \(transaction.senderID) к \(transaction.receiverID)"
        }
        
        if transaction.receiverID == 0 {
            cell?.detailTextLabel?.text = "Покупка (кем): \(transaction.senderID)"
        }
        
        return cell ?? UITableViewCell(frame: .zero)
    }
}




// MARK: - UITableViewDelegate

extension TransactionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
