//
//  Adapter.swift
//  DesignPattern
//
//  Created by LQ on 2023/5/27.
//

import Foundation

public protocol AuthenticationService {
    func login(email: String, password: String, success: @escaping (User, Token) -> Void, failure: @escaping (Error?) -> Void)
}

public struct User {
    public let email: String
    public let password: String
}

public struct Token {
    public let value: String
}

public struct GoogleUser {
    public let email: String
    public let password: String
    public let token: String
}

public class GoogleAuthenticator {
    public func login(email: String, password: String, completion: @escaping (GoogleUser?, Error?) -> Void) {
        
    }
}

public class GoogleAuthenticationAdapter: AuthenticationService {
    
    private var authenticator = GoogleAuthenticator()
    
    public func login(email: String, password: String, success: @escaping (User, Token) -> Void, failure: @escaping (Error?) -> Void) {
        authenticator.login(email: email, password: password) { googleUser, error in
            guard let googleUser = googleUser else {
                failure(error)
                return
            }
            
            let user = User(email: googleUser.email, password: googleUser.password)
            let token = Token(value: googleUser.token)
            success(user, token)
        }
    }
    
}
