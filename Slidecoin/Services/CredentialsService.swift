//
//  CredentialsService.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

protocol CredentialsServiceProtocol: class {
    
    func getCredentials() -> (Login, User)?
    func removeCredentials()
    
    func updateLogin(with login: Login)
    func updateUser(_ user: User)
}


final class CredentialsService: CredentialsServiceProtocol {
    
    func getCredentials() -> (Login, User)? {
        let defaults = UserDefaults.standard
        
        guard
            let accessToken = defaults.string(forKey: "access_token"),
            let refreshToken = defaults.string(forKey: "refresh_token"),
            let username = defaults.string(forKey: "username"),
            let email = defaults.string(forKey: "email"),
            let name = defaults.string(forKey: "name"),
            let surname = defaults.string(forKey: "surname")
        else { return nil }
        
        let balance = defaults.integer(forKey: "balance")
        let userID = defaults.integer(forKey: "user_id")
        
        let login = Login(refreshToken: refreshToken,
                          accessToken: accessToken,
                          message: username)
        
        let user = User(id: userID,
                        balance: balance,
                        username: username,
                        email: email,
                        name: name,
                        surname: surname)
        
        return (login, user)
    }
    
    func removeCredentials() {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "access_token")
        defaults.removeObject(forKey: "refresh_token")
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "surname")
        defaults.removeObject(forKey: "balance")
        defaults.removeObject(forKey: "user_id")
    }
    
    func updateLogin(with login: Login) {
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        let defaults = UserDefaults.standard
        defaults.set(login.message, forKey: "message")
        defaults.set(accessToken, forKey: "access_token")
        defaults.set(refreshToken, forKey: "refresh_token")
    }
    
    func updateUser(_ user: User) {
        let defaults = UserDefaults.standard
        defaults.set(user.id, forKey: "user_id")
        defaults.set(user.balance, forKey: "balance")
        defaults.set(user.email, forKey: "email")
        defaults.set(user.name, forKey: "name")
        defaults.set(user.surname, forKey: "surname")
        defaults.set(user.username, forKey: "username")
    }
}
