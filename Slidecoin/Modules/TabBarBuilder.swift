//
//  TabBarBuilder.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TabBarBuilder: UISplitViewControllerDelegate {
    
    static func build(login: Login, user: User) -> UITabBarController {
        Global.accessToken = login.accessToken
        Global.refreshToken = login.refreshToken
        
        let mainSvc = self.mainSvc(user: user)
        let usersSvc = self.usersSvc(user: user)
        let storeSvc = self.storeSvc(user: user)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainSvc, usersSvc, storeSvc]
        
        return tabBarController
    }
    
    
    // MARK: Private
    
    private static func mainSvc(user: User) -> UISplitViewController {
        let mainVc = MainViewController(user: user)
        let mainNvc = UINavigationController(rootViewController: mainVc)
        
        let transactionsVc = TransactionsViewController(user: user)
        let transactionsNvc = UINavigationController(rootViewController: transactionsVc)
        
        let mainSvc = UISplitViewController()
        mainSvc.delegate = mainVc
        mainSvc.preferredDisplayMode = .allVisible
        mainSvc.viewControllers = [mainNvc, transactionsNvc]
        
        let mainImage = UIImage(systemName: "house")
        let mainSelectedImage = UIImage(systemName: "house.fill")
        mainSvc.tabBarItem = UITabBarItem(title: "Главная",
                                          image: mainImage,
                                          selectedImage: mainSelectedImage)
        
        return mainSvc
    }
    
    private static func usersSvc(user: User) -> UISplitViewController {
        let usersVc = UsersViewController(currentUser: user)
        let usersNvc = UINavigationController(rootViewController: usersVc)
        
        let userVc = NoUserViewController("пользовател")
        
        let usersSvc = UISplitViewController()
        usersSvc.delegate = usersVc
        usersSvc.preferredDisplayMode = .allVisible
        usersSvc.viewControllers = [usersNvc, userVc]
        
        let usersImage = UIImage(systemName: "person.3")
        let usersSelectedImage = UIImage(systemName: "person.3.fill")
        usersSvc.tabBarItem = UITabBarItem(title: "Пользователи",
                                           image: usersImage,
                                           selectedImage: usersSelectedImage)
        
        return usersSvc
    }
    
    private static func storeSvc(user: User) -> UISplitViewController {
        let storeVc = StoreViewController(user: user)
        let storeNvc = UINavigationController(rootViewController: storeVc)
        
        let userVc = NoUserViewController("товар")
        
        let storeSvc = UISplitViewController()
        storeSvc.delegate = storeVc
        storeSvc.preferredDisplayMode = .allVisible
        storeSvc.viewControllers = [storeNvc, userVc]
        
        let storeImage = UIImage(systemName: "bag")
        let storeSelectedImage = UIImage(systemName: "bag.fill")
        storeSvc.tabBarItem = UITabBarItem(title: "Магазин",
                                           image: storeImage,
                                           selectedImage: storeSelectedImage)
        
        return storeSvc
    }
}
