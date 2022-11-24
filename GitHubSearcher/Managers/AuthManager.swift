//
//  AuthManager.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 23.11.2022.
//

import Foundation
import UIKit
import AuthenticationServices

class AuthManager: NSObject,ASWebAuthenticationPresentationContextProviding {
    
    let profileManager = ProfileUserManager()
    var isLoading = false
    
    func githubAuth(completion: @escaping () -> ()) {
        guard let signInURL =
                NetworkRequest.RequestType.signIn.networkRequest()?.url
        else {
            print("Could not create the sign in URL .")
            return
        }
        let callbackURLScheme = NetworkRequest.callbackURLScheme
        let authenticationSession = ASWebAuthenticationSession(
            url: signInURL,
            callbackURLScheme: callbackURLScheme) { [weak self] callbackURL, error in
                guard
                    error == nil,
                    let callbackURL = callbackURL,
                    let queryItems = URLComponents(string: callbackURL.absoluteString)?
                        .queryItems,
                    let code = queryItems.first(where: { $0.name == "code" })?.value,
                    let networkRequest =
                        NetworkRequest.RequestType.codeExchange(code: code).networkRequest()
                else {
                    print("An error occurred when attempting to sign in.")
                    return
                }
                
                self?.isLoading = true
                networkRequest.start(responseType: String.self) { [self] result in
                    switch result {
                    case .success:
                        self?.profileManager.getUser()
                        completion()
                    case .failure(let error):
                        print("Failed to exchange access code for tokens: \(error)")
                    }
                    
                }
            }
        
        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = true
        
        if !authenticationSession.start() {
            print("Failed to start ASWebAuthenticationSession")
        }
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
