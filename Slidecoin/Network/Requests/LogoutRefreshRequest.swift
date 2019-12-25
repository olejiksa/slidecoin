//
//  LogoutRefreshRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 25.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class LogoutRefreshRequest: BasePostRequest {
    
    private let refreshToken: String
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
        let endpoint = "\(RequestFactory.endpointRoot)logout/refresh"
        super.init(endpoint: endpoint)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
