//
//  ShopRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 24.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class ShopRequest: BaseGetRequest {
    
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
        let endpoint = "\(RequestFactory.endpointRoot)shop"
        super.init(endpoint: endpoint)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
