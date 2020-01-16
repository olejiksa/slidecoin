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
    
    static func register(username: String, password: String) -> RequestConfig<LoginParser> {
        let request = RegistrationRequest(username: username, password: password)
        let parser = LoginParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func secret(accessToken: String) -> RequestConfig<SecretParser> {
        let request = SecretRequest(accessToken: accessToken)
        let parser = SecretParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func users(accessToken: String) -> RequestConfig<UsersParser> {
        let request = UsersRequest(accessToken: accessToken)
        let parser = UsersParser()
    
        return .init(request: request, parser: parser)
    }
    
    static func deleteAllUsers() -> RequestConfig<LoginParser> {
        let request = DeleteAllUsersRequest()
        let parser = LoginParser()
    
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
}
