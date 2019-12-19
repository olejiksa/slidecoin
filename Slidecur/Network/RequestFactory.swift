//
//  RequestFactory.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

struct RequestFactory {
    
    static let endpointRoot = "http://dima.pythonanywhere.com/"
    
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
    
    static func users() -> RequestConfig<UsersParser> {
        let request = UsersRequest()
        let parser = UsersParser()
    
        return .init(request: request, parser: parser)
    }
    
    static func deleteAllUsers() -> RequestConfig<LoginParser> {
        let request = DeleteAllUsersRequest()
        let parser = LoginParser()
    
        return .init(request: request, parser: parser)
    }
    
    static func tokenRefresh(_ refreshToken: String) -> RequestConfig<AccessTokenParser> {
        let request = TokenRefreshRequest(refreshToken: refreshToken)
        let parser = AccessTokenParser()
        
        return .init(request: request, parser: parser)
    }
}
