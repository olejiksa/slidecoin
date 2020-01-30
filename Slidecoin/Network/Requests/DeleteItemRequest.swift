//
//  DeleteItemRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 31.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class DeleteItemRequest: BaseDeleteRequest {
    
    private let accessToken: String
    
    init(productID: Int, accessToken: String) {
        self.accessToken = accessToken
        
        let endpoint = "\(RequestFactory.endpointRoot)deleteitem"
        let parameters = ["id": productID]
        
        super.init(endpoint: endpoint, parameters: parameters)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
