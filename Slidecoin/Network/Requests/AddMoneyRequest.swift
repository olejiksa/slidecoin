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
    
    init(userID: Int, amount: Int) {
        let endpoint = "\(RequestFactory.endpointRoot)addmoney"
        super.init(endpoint: endpoint, parameters: ["id": userID,
                                                    "amount": amount])
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
