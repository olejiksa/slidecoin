//
//  Assembly.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

final class Assembly {
    
    static let alertService: AlertServiceProtocol = AlertService()
    static let credentialsService: CredentialsServiceProtocol = CredentialsService()
    static let requestSender: RequestSenderProtocol = RequestSender()
}
