//
//  AddMoneyRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 30.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class AddMoneyRequest: BasePostRequest {
    
    private let accessToken: String
    
    init(userID: Int,
         amount: Int,
         accessToken: String) {
        self.accessToken = accessToken
        
        let endpoint = "\(RequestFactory.endpointRoot)addmoney"
        super.init(endpoint: endpoint, parameters: ["id": userID,
                                                    "amount": amount])
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
