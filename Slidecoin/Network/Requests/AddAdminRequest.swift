//
//  AddAdminRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 03.02.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class AddAdminRequest: BasePostRequest {
    
    init(email: String) {
        let endpoint = "\(RequestFactory.endpointRoot)add_new_admin"
        super.init(endpoint: endpoint, parameters: ["email": email])
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

