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
    
    init(name: String,
         price: Int,
         description: String) {
        let endpoint = "\(RequestFactory.endpointRoot)shop/additem"
        super.init(endpoint: endpoint, parameters: ["name": name,
                                                    "price": price,
                                                    "description": description])
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
