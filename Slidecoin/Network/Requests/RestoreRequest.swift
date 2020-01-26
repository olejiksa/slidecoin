//
//  RestoreRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 17.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit

final class RestoreRequest: BasePostRequest {
    
    init(email: String) {
        let endpoint = "\(RequestFactory.endpointRoot)password/forgot"
        let parameters = ["email": email]
                          
        super.init(endpoint: endpoint, parameters: parameters)
    }
}
