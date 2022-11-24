//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 22.11.2022.
//

import UIKit

final class LoginViewController: UIViewController {
    
    let profileManager = ProfileUserManager()
    let authManager = AuthManager()
    var isLoading = false
    var isShowingRepositoriesView = false
    
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
        view.backgroundColor = .white
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
        authManager.githubAuth(completion: {
            self.present(TabBarViewController(), animated: true)
            print("success")
        })
    }
    
    func appeared() {
        profileManager.getUser()
    }
    
}

