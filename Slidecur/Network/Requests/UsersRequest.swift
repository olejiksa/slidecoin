//
//  UsersRequest.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

final class UsersRequest: BaseGetRequest {
    
    init() {
        let endpoint = "\(RequestFactory.endpointRoot)users"
        super.init(endpoint: endpoint)
    }
}
