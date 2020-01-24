//
//  RequestFactory.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

struct RequestFactory {
    
    static let endpointRoot = "https://dima.pythonanywhere.com/"
    static let endpointWeb = "https://slide-wallet.web.app"
    
    static func login(username: String, password: String) -> RequestConfig<LoginParser> {
        let request = LoginRequest(username: username, password: password)
        let parser = LoginParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func register(username: String,
                         password: String,
                         email: String,
                         name: String,
                         surname: String) -> RequestConfig<LoginParser> {
        let request = RegistrationRequest(username: username,
                                          password: password,
                                          email: email,
                                          name: name,
                                          surname: surname)
        let parser = LoginParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func restore(email: String) -> RequestConfig<MessageParser> {
        let request = RestoreRequest(email: email)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func reset(accessToken: String,
                      currentPassword: String,
                      newPassword: String) -> RequestConfig<MessageParser> {
        let request = ResetRequest(accessToken: accessToken,
                                   currentPassword: currentPassword,
                                   newPassword: newPassword)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func reset(newPassword: String, token: String) -> RequestConfig<MessageParser> {
        let request = ResetEmailRequest(newPassword: newPassword, token: token)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func secret(accessToken: String) -> RequestConfig<SecretParser> {
        let request = SecretRequest(accessToken: accessToken)
        let parser = SecretParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func transfer(accessToken: String,
                         receiver: User,
                         amount: Int) -> RequestConfig<MessageParser> {
        let request = TransferRequest(accessToken: accessToken,
                                      receiverUsername: receiver.username,
                                      amount: amount)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func users(accessToken: String) -> RequestConfig<UsersParser> {
        let request = UsersRequest(accessToken: accessToken)
        let parser = UsersParser()
    
        return .init(request: request, parser: parser)
    }
    
    static func user(_ identifier: Int, accessToken: String) -> RequestConfig<UserParser> {
        let request = UserByIDRequest(accessToken: accessToken, identifier: identifier)
        let parser = UserParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func deleteAllUsers() -> RequestConfig<LoginParser> {
        let request = DeleteAllUsersRequest()
        let parser = LoginParser()
    
        return .init(request: request, parser: parser)
    }
    
    static func transactions(accessToken: String) -> RequestConfig<TransactionsParser> {
        let request = TransactionsRequest(accessToken: accessToken)
        let parser = TransactionsParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func tokenRefresh(refreshToken: String) -> RequestConfig<AccessTokenParser> {
        let request = TokenRefreshRequest(refreshToken: refreshToken)
        let parser = AccessTokenParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func logoutAccess(accessToken: String) -> RequestConfig<MessageParser> {
        let request = LogoutAccessRequest(accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func logoutRefresh(refreshToken: String) -> RequestConfig<MessageParser> {
        let request = LogoutRefreshRequest(refreshToken: refreshToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func shop(accessToken: String) -> RequestConfig<ShopParser> {
        let request = ShopRequest(accessToken: accessToken)
        let parser = ShopParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func buy(id: Int, accessToken: String) -> RequestConfig<MessageParser> {
        let request = BuyRequest(id: id, accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
}
