//
//  ResetEmailRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 17.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit

final class ResetEmailRequest: BasePostRequest {
    
    init(newPassword: String, token: String) {
        let endpoint = "\(RequestFactory.endpointRoot)/password/forgot/reset/\(token)"
        let parameters = ["new_password": newPassword]
                          
        super.init(endpoint: endpoint, parameters: parameters)
    }
}
