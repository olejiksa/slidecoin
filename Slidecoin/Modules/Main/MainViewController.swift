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
    
    private var login: Login
    private var user: User
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var transactionsButton: BigButton!
    
    
    // MARK: Lifecycle
    
    init(login: Login, user: User) {
        self.login = login
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
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        let vc = TransactionsViewController(user: user, accessToken: accessToken, refreshToken: refreshToken)
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
        navigationItem.leftBarButtonItem = infoButton
        
        let userImage = UIImage(systemName: "person.crop.circle")
        let userButton = UIBarButtonItem(image: userImage,
                                         style: .done,
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
        messageLabel.text = user.username
        sumLabel.text = "\(user.balance) \(Global.currencySymbol)"
        
        if let svc = splitViewController {
            transactionsButton.isHidden = svc.displayMode == .allVisible && !svc.isCollapsed
        }
    }
    
    @objc private func userDidTap() {
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        let vc = UserViewController(user: user,
                                    currentUser: user,
                                    accessToken: accessToken,
                                    refreshToken: refreshToken,
                                    isCurrent: true)
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    @objc private func infoDidTap() {
        let vc = AboutViewController()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    @IBAction private func accentColorDidTap() {
        let vc = AccentColorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refresh() {
        guard let accessToken = login.accessToken else { return }
        
        let config = RequestFactory.user(user.id, accessToken: accessToken)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()

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
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
