//
//  TransferRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 17.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class TransferRequest: BasePostRequest {
    
    init(receiverUsername: String,
         amount: Int) {
        let endpoint = "\(RequestFactory.endpointRoot)transaction"
        let parameters = ["receiver_username": receiverUsername,
                          "amount": amount] as [String: Any]
        
        super.init(endpoint: endpoint, parameters: parameters)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
