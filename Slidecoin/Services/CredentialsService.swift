//
//  CredentialsService.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

protocol CredentialsServiceProtocol: class {
    
    func getCredentials() -> Login?
    func removeCredentials()
    func updateCredentials(with login: Login)
    
    func getMoney() -> Decimal?
    func updateMoney(with sum: Decimal)
}


final class CredentialsService: CredentialsServiceProtocol {
    
    func getCredentials() -> Login? {
        let defaults = UserDefaults.standard
        
        guard
            let message = defaults.string(forKey: "message"),
            let accessToken = defaults.string(forKey: "access_token"),
            let refreshToken = defaults.string(forKey: "refresh_token")
        else { return nil }
        
        return .init(refreshToken: refreshToken,
                     accessToken: accessToken,
                     message: message)
    }
    
    func removeCredentials() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "message")
        defaults.removeObject(forKey: "access_token")
        defaults.removeObject(forKey: "refresh_token")
        defaults.removeObject(forKey: "money")
    }
    
    func updateCredentials(with login: Login) {
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        let defaults = UserDefaults.standard
        defaults.set(login.message, forKey: "message")
        defaults.set(accessToken, forKey: "access_token")
        defaults.set(refreshToken, forKey: "refresh_token")
    }
    
    func getMoney() -> Decimal? {
        let defaults = UserDefaults.standard
        
        guard
            let string = defaults.string(forKey: "money"),
            let sum = Decimal(string: string)
        else { return nil }
        
        return sum
    }
    
    func updateMoney(with sum: Decimal) {
        let defaults = UserDefaults.standard
        let string = String(describing: sum)
        defaults.set(string, forKey: "money")
    }
}
