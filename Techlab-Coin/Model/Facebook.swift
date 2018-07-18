//
//  Facebook.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 14/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import Unbox

typealias FBSuccessHandler = (_ success:AnyObject) -> Void
typealias FBFailHandler = (_ success:AnyObject) -> Void


class FacebookClass: NSObject {
    
    var vc: UIViewController!
    var loginFail: FBFailHandler?
    var loginSucess: FBSuccessHandler?
    
    var fbData: FacebookData?
    
    static var facebookClass: FacebookClass!
    
    class func sharedInstance() -> FacebookClass {
        
        if(facebookClass == nil) {
            facebookClass = FacebookClass()
        }
        return facebookClass
    }
    
    //MARK: - Logout Facebook
    
    func logoutFromFacebook() {
        
        if(Reachability.isNetworkAvailable()) {
            let loginManager = LoginManager()
            loginManager.logOut()
        }
        else {
            print("No internet Connection.")
        }
    }
    
    //MARK: - Login with Facebook
    
    func loginWithFacebook(viewController: UIViewController, successHandler: @escaping FBSuccessHandler, failHandler: @escaping FBFailHandler) {
        self.logoutFromFacebook()
        vc = viewController
        loginFail = failHandler
        loginSucess = successHandler
        
        if(Reachability.isNetworkAvailable()) {
            
            if(AccessToken.current == nil) {
                
                let loginManager = LoginManager()
                loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: viewController) { (loginResult) in
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                        self.loginFail!(error.localizedDescription as AnyObject)
                    case .cancelled:
                        print("User cancelled login.")
                        self.loginFail!("User cancelled login." as AnyObject)
                    case .success( _, _, let tokenstr):
                        print("Logged in! \(tokenstr)")
                        AccessToken.current = tokenstr
                        self.getUserInfoFromFB()
                    }
                }
            }
            else {
                //AccessToken.current = strToken
                self.getUserInfoFromFB()
            }
            
        }
        else {
            print("No internet Connection.")
            self.loginFail!("No internet Connection." as AnyObject)
        }
    }
    
    func getUserInfoFromFB() {
        
        let params = ["fields":"cover,picture.type(large),id,name,first_name,last_name,email,location"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                self.loginFail!(error.localizedDescription as AnyObject)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    let data: FacebookData? = try? unbox(dictionary: responseDictionary)
                    self.fbData = data
                    self.loginSucess!(responseDictionary as AnyObject)
                }
            }
        }
        
    }
    
    //MARK: - Get List Of Facebook Friends
    
    func getFacebookFriends(viewController: UIViewController, successHandler: @escaping FBSuccessHandler, failHandler: @escaping FBFailHandler) {
        
        vc = viewController
        loginFail = failHandler
        loginSucess = successHandler
        
        if(Reachability.isNetworkAvailable()) {
            
            if(AccessToken.current == nil) {
                
                let loginManager = LoginManager()
                
                loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: viewController) { (loginResult) in
                    
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                        self.loginFail!(error.localizedDescription as AnyObject)
                    case .cancelled:
                        print("User cancelled login.")
                        self.loginFail!("User cancelled login." as AnyObject)
                    case .success( _, _, let tokenstr):
                        print("Logged in! \(tokenstr)")
                        AccessToken.current = tokenstr
                        self.getUserFacebookFriendsFromFB()
                    }
                }
                
            }
            else {
                self.getUserFacebookFriendsFromFB()
            }
        }
        else {
            print("No internet Connection.")
            self.loginFail!("No internet Connection." as AnyObject)
        }
    }
    
    
    func getUserFacebookFriendsFromFB() {
        
        let params = ["fields":"cover,picture.type(large),id,name,first_name,last_name,gender,birthday,email,location,hometown"]
        let graphRequest = GraphRequest(graphPath: "me/friends", parameters: params)
        
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
                
            case .failed(let error):
                print("error in graph request:", error)
                self.loginFail!(error.localizedDescription as AnyObject)
                break
                
            case .success(let graphResponse):
                
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    self.loginSucess!(responseDictionary as AnyObject)
                }
            }
        }
    }
}
