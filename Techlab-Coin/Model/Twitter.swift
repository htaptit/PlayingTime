//
//  Twitter.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 14/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation

import UIKit
import TwitterKit
import Fabric

class TwitterClass: NSObject {
    
    var AppConsumerKey: String = "LBJskZi2ksL7s2lLhS6LzavgW"
    var AppSecrat: String = "RYAcPExR6NI7c3scO6msVg0SLd9F5Ea4G1OIb3swzr2Qefrj1X"
    var strUserId: String = ""
    
    typealias TWSuccessHandler = (_ success:AnyObject) -> Void
    typealias TWFailHandler = (_ success:AnyObject) -> Void
    
    var vc: UIViewController!
    var loginFail: TWFailHandler?
    var loginSucess: TWSuccessHandler?
    
    var email: String?
    
    static var twitterClass: TwitterClass!
    
    class func sharedInstance() -> TwitterClass {
        
        if(twitterClass == nil) {
            twitterClass = TwitterClass()
        }
        return twitterClass
    }
    
    
    
    func loginWithTwitter(viewController: UIViewController, successHandler: @escaping TWSuccessHandler, failHandler: @escaping TWFailHandler) {
        
        vc = viewController
        loginFail = failHandler
        loginSucess = successHandler
        
        if(Reachability.isNetworkAvailable()) {
            
            TWTRTwitter.sharedInstance().start(withConsumerKey: AppConsumerKey, consumerSecret: AppSecrat)
            
            TWTRTwitter.sharedInstance().logIn(with: vc) { (session, error) in
                if((session) != nil) {
                    
                    TWTRTwitter.sharedInstance().sessionStore.saveSession(withAuthToken: (session?.authToken)!, authTokenSecret: (session?.authTokenSecret)!, completion: { (session, error) in
                        
                    })
                    
                    
                    TWTRAPIClient.withCurrentUser().requestEmail(forCurrentUser: { (email, error) in
                        self.email = email
                    })
                    
                    self.strUserId = (session?.userID)!
                    
                    print("authToken    :\(String(describing: session?.authToken))")
                    print("userName     :\(String(describing: session?.userName))")
                    
                    print("userID       :\(self.strUserId)")
                    
                    self.loginSucess!(session as AnyObject)
                }
                else {
                    self.loginFail!(error?.localizedDescription as AnyObject)
                }
                
            }
        }
        else {
            print("No internet Connection.")
            self.loginFail!("No internet Connection." as AnyObject)
        }
        
    }
    
    func getAccountInfo(userID: String, _data: @escaping(Data?) -> ()) {
        let statusesShowEndpoint = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let params = ["include_email": "true"]
        
        var clientError : NSError?
        
        let request = TWTRAPIClient.withCurrentUser().urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)

        TWTRAPIClient.withCurrentUser().sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            _data(data)
        }
    }
    
    func logoutFromTwitter() {
        
        if(Reachability.isNetworkAvailable()) {
            TWTRTwitter.sharedInstance().sessionStore.logOutUserID(self.strUserId)
        }
        else {
            print("No internet Connection.")
            self.loginFail!("No internet Connection." as AnyObject)
        }
    }
    
}

