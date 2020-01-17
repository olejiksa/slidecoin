//
//  TabBarBuilder.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TabBarBuilder {
    
    static func build(with login: Login) -> UITabBarController {
        let mainNvc = self.mainNvc(with: login)
        let usersNvc = self.usersNvc(with: login)
        let storeNvc = self.storeNvc()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainNvc, usersNvc, storeNvc]
        
        return tabBarController
    }
    
    
    // MARK: Private
    
    private static func mainNvc(with login: Login) -> UINavigationController {
        let mainVc = MainViewController(login: login)
        let mainNvc = UINavigationController(rootViewController: mainVc)
        
        let mainImage = UIImage(systemName: "house")
        let mainSelectedImage = UIImage(systemName: "house.fill")
        mainNvc.tabBarItem = UITabBarItem(title: "Главная",
                                          image: mainImage,
                                          selectedImage: mainSelectedImage)
        
        return mainNvc
    }
    
    private static func usersNvc(with login: Login) -> UINavigationController {
        let mainVc = UsersViewController(login: login)
        let mainNvc = UINavigationController(rootViewController: mainVc)
        
        let mainImage = UIImage(systemName: "person.3")
        let mainSelectedImage = UIImage(systemName: "person.3.fill")
        mainNvc.tabBarItem = UITabBarItem(title: "Пользователи",
                                          image: mainImage,
                                          selectedImage: mainSelectedImage)
        
        return mainNvc
    }
    
    private static func storeNvc() -> UINavigationController {
        let storeVc = StoreViewController()
        let storeNvc = UINavigationController(rootViewController: storeVc)
        
        let storeImage = UIImage(systemName: "bag")
        let storeSelectedImage = UIImage(systemName: "bag.fill")
        storeNvc.tabBarItem = UITabBarItem(title: "Магазин",
                                           image: storeImage,
                                           selectedImage: storeSelectedImage)
        
        return storeNvc
    }
}
