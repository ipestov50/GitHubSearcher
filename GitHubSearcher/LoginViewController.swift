//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 22.11.2022.
//

import UIKit
import AuthenticationServices

final class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    var isLoading = false
    var isShowingRepositoriesView = false
    
    let authManager = AuthentificationManager()
    let profileManager = ProfileUserManager()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.addTarget(self, action: #selector(githubLogin), for: .touchUpInside)
        setupLayout()
        appeared()
    }
    
    func setupLayout() {
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    @objc private func githubLogin() {
        githubAuth()
    }
    
    func githubAuth() {
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
                    // 2
                    let queryItems = URLComponents(string: callbackURL.absoluteString)?
                        .queryItems,
                    // 3
                    let code = queryItems.first(where: { $0.name == "code" })?.value,
                    // 4
                    let networkRequest =
                        NetworkRequest.RequestType.codeExchange(code: code).networkRequest()
                else {
                    // 5
                    print("An error occurred when attempting to sign in.")
                    return
                }
                
                self?.isLoading = true
                networkRequest.start(responseType: String.self) { [self] result in
                    switch result {
                    case .success:
                        self?.profileManager.getUser()
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
    
    func appeared() {
        profileManager.getUser()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}

