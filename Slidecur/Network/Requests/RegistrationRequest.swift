//
//  RegistrationRequest.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

final class RegistrationRequest: BasePostRequest {
    
    init(username: String, password: String) {
        let endpoint = "\(RequestFactory.endpointRoot)registration"
        let parameters = ["username": username, "password": password]
        
        super.init(endpoint: endpoint, parameters: parameters)
    }
}
