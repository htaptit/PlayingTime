//
//  TechLabNetwork.swift
//  WorldWide
//
//  Created by Hoang Trong Anh on 4/23/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Moya

enum MyApi {
    case newAccount(passwd: String, name: String, email: String, type: Int)
    case accounts(email: String, type: Int)
    case unlockAccount(address: String, passwd: String)
    case getBalance(address: String)
    case sendTransaction(from: String, to: String, value: String, passwd: String)
    case getTransactionCount(addr: String)
    case checkIsAddress(addr: String)
    case transactionHistory(email: String, type: Int)
    case getTransaction(hash: String)
    case getContacts(email: String, type: Int)
    case newContacts(email: String, type: Int, address: String)
    case getEmailByName(name: String)
    case getEmailByAddress(address: String)
    case getNameByAddress(address: String)
}

extension MyApi: TargetType {
    
    var baseURL: URL { return URL(string: "http://hoangs-mac-mini.local:9001")! }
    
    var method: Moya.Method {
        switch self {
        case .newAccount, .sendTransaction, .unlockAccount, .newContacts:
            return .post
        case .accounts,
             .getBalance,
             .getTransactionCount,
             .checkIsAddress,
             .transactionHistory,
             .getTransaction,
             .getContacts,
             .getEmailByName,
             .getEmailByAddress,
             .getNameByAddress:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .newAccount:
            return "/newAccount"
        case .accounts:
            return "/accounts"
        case .getBalance:
            return "/getBalance"
        case .sendTransaction:
            return "/sendTransaction"
        case .getTransactionCount:
            return "/getTransactionCount"
        case .unlockAccount:
            return "/unlockAccount"
        case .checkIsAddress:
            return "/checkIsAddress"
            
        case .transactionHistory:
            return "/transactionHistory"
        case .getTransaction:
            return "/getTransaction"
            
        case .newContacts:
            return "/newContacts"
        case .getContacts:
            return "/getContacts"
        case .getEmailByName:
            return "/getEmailByName"
        case .getEmailByAddress:
            return "/getEmailByAddress"
        case .getNameByAddress:
            return "/getNameByAddress"
        }
    }
    
    var parameterEncoding:ParameterEncoding {
        switch self {
            
        case .newAccount,
             .accounts,
             .getBalance,
             .sendTransaction,
             .getTransactionCount,
             .unlockAccount,
             .checkIsAddress,
             .transactionHistory,
             .getTransaction,
             .newContacts,
             .getContacts,
             .getEmailByName,
             .getEmailByAddress,
             .getNameByAddress:
            
            return URLEncoding.queryString
        }
        
    }
    
    var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .newAccount(let passwd, let name, let email, let type):
            params["password"] = passwd
            params["name"] = name
            params["email"] = email
            params["type"] = type
            
            return params
        case .accounts(let email, let type):
            params["email"] = email
            params["type"] = type
            
            return params
        case .unlockAccount(let address, let passwd):
            params["address"] = address
            params["password"] = passwd
            
            return params
        case .getBalance(let address):
            params["address"] = address
            
            return params
        case .sendTransaction(let from, let to, let value, let passwd):
            params["password"] = passwd
            params["from"] = from
            params["to"] = to
            params["value"] = value
            
            return params
            
        case .getTransactionCount(let addr):
            params["address"] = addr
            
            return params
        case .checkIsAddress(let addr):
            params["address"] = addr
            
            return params
            
        case .transactionHistory(let email, let type):
            params["email"] = email
            params["type"] = type
            
            return params
        case .getTransaction(let hash):
            params["hash"] = hash
            
            return params

        case .newContacts(let email, let type, let address):
            params["email"] = email
            params["type"] = type
            params["address"] = address
            
            return params
        case .getContacts(let email, let type):
            params["email"] = email
            params["type"] = type
            
            return params
            
        case .getEmailByName(let name):
            params["name"] = name
            
            return params
            
        case .getEmailByAddress(let address):
            params["address"] = address
            
            return params
        case .getNameByAddress(let address):
            params["address"] = address
            
            return params
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .newAccount,
             .accounts,
             .getBalance,
             .sendTransaction,
             .getTransactionCount,
             .unlockAccount,
             .checkIsAddress,
             .transactionHistory,
             .getTransaction,
             .newContacts,
             .getContacts,
             .getEmailByName,
             .getEmailByAddress,
             .getNameByAddress:
            if let _ = self.parameters {
                return .requestParameters(parameters: self.parameters!, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }
}

struct MyApiAdap {
    static let provider = MoyaProvider<MyApi>()
    
    static func request(target: MyApi, success successCallback: @escaping (Response) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response)
                } else {
                    let error = NSError(domain: target.baseURL.absoluteString, code: 0, userInfo: [NSLocalizedDescriptionKey: "### Code : \(response.statusCode), description: \(response.description) ###"])
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
}

