//
//  RequestFactory.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct RequestFactory {
    
    static let endpointRoot = "http://dima.pythonanywhere.com/"
    
    static func login(username: String, password: String) -> RequestConfig<LoginParser> {
        let request = LoginRequest(username: username, password: password)
        let parser = LoginParser()
        
        return RequestConfig<LoginParser>(request: request, parser: parser)
    }
    
    static func register(username: String, password: String) -> RequestConfig<LoginParser> {
        let request = RegistrationRequest(username: username, password: password)
        let parser = LoginParser()
        
        return RequestConfig<LoginParser>(request: request, parser: parser)
    }
}
