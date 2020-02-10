//
//  StoreViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class StoreViewController: UIViewController {

    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    
    private let cellID = "\(ProductCell.self)"
    
    private var products: [Product] = []
    private var searchedProducts: [Product] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    private var user: User
    
    @IBOutlet private weak var noItemsLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
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
        setupKeyboard()
        setupCollectionView()
        setupRefreshControl()
        setupSearchController()
        
        obtainProducts()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Магазин"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let cartImage = UIImage(systemName: "cart")
        let cartButton = UIBarButtonItem(image: cartImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(navigateToPurchases))
        navigationItem.leftBarButtonItem = cartButton

        if user.isAdmin {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(addItem))
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    private func setupKeyboard() {
        collectionView.bottomAnchor.constraint(lessThanOrEqualTo: keyboardLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: cellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func filterContent(for searchText: String) {
        searchedProducts = products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func obtainProducts() {
        if products.isEmpty {
            spinner.startAnimating()
            noItemsLabel.isHidden = true
        }
        
        let config = RequestFactory.shop()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.spinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.products = products
                    self.collectionView.reloadData()
                    self.noItemsLabel.isHidden = !products.isEmpty
                    
                case .failure(let error):
                    switch error {
                    case is ResponseError:
                        let refreshConfig = RequestFactory.tokenRefresh()
                        self.requestSender.send(config: refreshConfig) { [weak self] result in
                            guard let self = self else { return }
                            
                            switch result {
                            case .success(let accessToken):
                                Global.accessToken = accessToken
                                self.userDefaultsService.updateToken(access: accessToken)
                                self.refreshControl.beginRefreshing()
                                self.obtainProducts()
                                
                            case .failure(let error):
                                self.spinner.stopAnimating()
                                self.refreshControl.endRefreshing()
                                let alert = self.alertService.alert(error.localizedDescription)
                                self.present(alert, animated: true)
                            }
                        }
                        
                    default:
                        self.spinner.stopAnimating()
                        self.refreshControl.endRefreshing()
                        let alert = self.alertService.alert(error.localizedDescription)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @objc private func refresh() {
        obtainProducts()
    }
    
    @objc private func navigateToPurchases() {
        let vc = PurchasesViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addItem() {
        let vc = AddItemViewController(isAdd: .add)
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
}




// MARK: - UICollectionViewDataSource

extension StoreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchController.isActive ? searchedProducts.count : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ProductCell
        
        let product = searchController.isActive ? searchedProducts[indexPath.row] : products[indexPath.row]
        cell?.setup(product: product)
        
        return cell ?? .init()
    }
}




// MARK: - UICollectionViewDelegate

extension StoreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let product = searchController.isActive ? searchedProducts[index] : products[index]
        let vc = ProductViewController(product: product,
                                       alreadyPurchased: false,
                                       isAdmin: user.isAdmin)
        
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        
        if let splitVc = splitViewController, !splitVc.isCollapsed {
            let nvc = UINavigationController(rootViewController: vc)
            splitVc.showDetailViewController(nvc, sender: self)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}




// MARK: - UISearchResultsUpdating

extension StoreViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContent(for: searchText)
        collectionView.reloadData()
    }
}




// MARK: - UISplitViewControllerDelegate

extension StoreViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
