//
//  DeleteUserRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 31.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class DeleteUserRequest: BaseDeleteRequest {
    
    init(userID: Int) {
        let endpoint = "\(RequestFactory.endpointRoot)deleteuser"
        let parameters = ["id": userID]
        super.init(endpoint: endpoint, parameters: parameters)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
