//
//  MainViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class MainViewController: UIViewController {

    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    
    private let refreshControl = UIRefreshControl()
    
    private var user: User
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        return numberFormatter
    }
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var transactionsButton: BigButton!
    
    
    // MARK: Lifecycle
    
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
        setupRefreshControl()
        setupView()
    }
    
    
    // MARK: Actions
    
    @IBAction private func transactionsDidTap() {
        let vc = TransactionsViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let infoImage = UIImage(systemName: "info.circle")
        let infoButton = UIBarButtonItem(image: infoImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(infoDidTap))
        
        let gearImage = UIImage(systemName: "gear")
        let gearButton = UIBarButtonItem(image: gearImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(accentColorDidTap))
        
        navigationItem.leftBarButtonItems = [infoButton, gearButton]
        
        let userImage = UIImage(systemName: "person.crop.circle")
        let userButton = UIBarButtonItem(image: userImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(userDidTap))
        navigationItem.rightBarButtonItem = userButton
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    private func setupView() {
        messageLabel.text = "Добро пожаловать, \(user.username)"
        guard let balance = numberFormatter.string(from: user.balance as NSNumber) else { return }
        sumLabel.text = "\(balance) \(Global.currencySymbol)"
        
        if let svc = splitViewController {
            let isHidden = svc.displayMode == .allVisible && !svc.isCollapsed
            infoLabel.isHidden = isHidden
            transactionsButton.isHidden = isHidden
        }
    }
    
    @objc private func userDidTap() {
        let vc = UserViewController(user: user,
                                    currentUser: user,
                                    isCurrent: true)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
    
    @objc private func infoDidTap() {
        let vc = AboutViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
    
    @IBAction private func accentColorDidTap() {
        let vc = AccentColorViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
    
    @IBAction private func tasksDidTap() {
        let vc = TasksViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refresh() {
        let config = RequestFactory.user(by: user.id)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            self.scrollView.contentOffset.x = 0

            switch result {
            case .success(let user):
                self.user = user
                self.userDefaultsService.updateUser(user)
                self.setupView()
                
            case .failure(let error):
                let alert = self.alertService.alert(error.localizedDescription)
                self.present(alert, animated: true)
            }
        }
    }
}




// MARK: - UISplitViewControllerDelegate

extension MainViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
