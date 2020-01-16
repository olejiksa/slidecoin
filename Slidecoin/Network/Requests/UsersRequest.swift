//
//  UsersRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class UsersRequest: BaseGetRequest {
    
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
        let endpoint = "\(RequestFactory.endpointRoot)users"
        super.init(endpoint: endpoint)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
