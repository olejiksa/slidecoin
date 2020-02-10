//
//  UpdateItemRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 09.02.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class UpdateItemRequest: BasePostRequest {
    
    init(productID: Int, name: String, price: Int, description: String) {
        let endpoint = "\(RequestFactory.endpointRoot)updateitem"
        let parameters = ["id": productID, "name": name, "price": price, "description": description] as [String : Any]
        
        super.init(endpoint: endpoint, parameters: parameters)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
