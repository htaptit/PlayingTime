//
//  EthServiceRequest.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 6/29/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import APIKit
import JSONRPCKit

struct EthServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    
    // alias
    typealias Response = Batch.Responses
    
    // variables
    let batch: Batch
    
    var baseURL: URL {
        return URL(string: "http://192.168.0.5:8545")!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/"
    }
    
    var parameters: Any? {
        return batch.requestObject
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}

struct CastError<ExpectedType>: Error {
    let actualValue: Any
    let expectedType: ExpectedType.Type
}


// struct request
struct EthGetBalance: JSONRPCKit.Request {
    // alias
    typealias Response = String
    
    // variable
    let address: String
    let quantity: String
    
    var method: String {
        return "eth_getBalance"
    }
    
    var parameters: Any? {
        return [address, quantity]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct EthGetAccounts: JSONRPCKit.Request {
    // alias
    typealias Response = [String]

    var method: String {
        return "eth_accounts"
    }
    
    var parameters: Any? {
        return nil
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}


