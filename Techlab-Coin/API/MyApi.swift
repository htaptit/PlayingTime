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
    case getBalance(address: String)
}

extension MyApi: TargetType {
    
    var baseURL: URL { return URL(string: "http://192.168.0.196:9001")! }
    
    var method: Moya.Method {
        switch self {
        case .newAccount:
            return .post
        case .accounts, .getBalance:
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
        }
    }
    
    var parameterEncoding:ParameterEncoding {
        switch self {
        case .newAccount, .accounts, .getBalance:
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
        case .getBalance(let address):
            params["address"] = address
            
            return params
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
//        switch self {
//        case .newAccount:
//            return ["Content-Type": "application/x-www-form-urlencoded"]
//        case .accounts:
//            return ["Content-Type": "application/json"]
//        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .newAccount, .accounts, .getBalance:
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
