//
//  RequestConfig.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case urlParserError
    case dataParserError
}

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}

struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}
