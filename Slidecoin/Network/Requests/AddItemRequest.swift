//
//  AddItemRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class AddItemRequest: BasePostRequest {
    
    
    private let accessToken: String
    
    init(name: String,
         price: Int,
         description: String,
         accessToken: String) {
        self.accessToken = accessToken
        
        let endpoint = "\(RequestFactory.endpointRoot)shop/additem"
        super.init(endpoint: endpoint, parameters: ["name": name,
                                                    "price": price,
                                                    "description": description])
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
