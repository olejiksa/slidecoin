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
    
    private var refreshControl = UIRefreshControl()
    private var isFilterEnabled = false
    
    private var transactions: [Transaction] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupRefreshControl()
        
        obtainTransactions()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Транзакции"
        
        let filterIcon = UIImage(systemName: "line.horizontal.3.decrease.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filter))
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
        let config = RequestFactory.transactions()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    self.refreshControl.endRefreshing()
                    self.transactions = transactions
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
        let icon = isFilterEnabled ? UIImage(systemName: "line.horizontal.3.decrease.circle.fill") : UIImage(systemName: "line.horizontal.3.decrease.circle")
        navigationItem.rightBarButtonItem?.image = icon
    }
}




// MARK: - UITableViewDataSource

extension TransactionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SubtitleCell
        let transaction = transactions[indexPath.row]
        cell?.textLabel?.text = "\(transaction.amount) ₿"
        cell?.textLabel?.textColor = transaction.amount >= 0 ? UIColor.systemGreen : UIColor.systemRed
        cell?.detailTextLabel?.text = "От \(transaction.senderID) к \(transaction.receiverID)"
        return cell ?? UITableViewCell(frame: .zero)
    }
}




// MARK: - UITableViewDelegate

extension TransactionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
