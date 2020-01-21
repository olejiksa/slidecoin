//
//  UserByIDRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class UserByIDRequest: BaseGetRequest {
    
    private let accessToken: String
    
    init(accessToken: String, identifier: Int) {
        self.accessToken = accessToken
        let endpoint = "\(RequestFactory.endpointRoot)user/\(identifier)"
        super.init(endpoint: endpoint)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
