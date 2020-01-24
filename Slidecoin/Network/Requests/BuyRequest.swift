//
//  BuyRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 24.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class BuyRequest: BasePostRequest {
    
    private let id: Int
    private let accessToken: String
    
    init(id: Int, accessToken: String) {
        self.id = id
        self.accessToken = accessToken
        let endpoint = "\(RequestFactory.endpointRoot)shop/buy"
        super.init(endpoint: endpoint, parameters: ["id": id])
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
