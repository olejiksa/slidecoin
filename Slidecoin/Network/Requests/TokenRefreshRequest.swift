//
//  TokenRefreshRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class TokenRefreshRequest: BasePostRequest {
    
    init() {
        let endpoint = "\(RequestFactory.endpointRoot)token/refresh"
        super.init(endpoint: endpoint)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let refreshToken = Global.refreshToken else { return request }
        request?.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
