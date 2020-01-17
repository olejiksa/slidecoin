//
//  RegistrationRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

final class RegistrationRequest: BasePostRequest {
    
    init(username: String,
         password: String,
         email: String,
         name: String,
         surname: String) {
        let endpoint = "\(RequestFactory.endpointRoot)registration"
        let parameters = ["username": username,
                          "password": password,
                          "email": email,
                          "name": name,
                          "surname": surname]
        
        super.init(endpoint: endpoint, parameters: parameters)
    }
}
