//
//  ProfileManager.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 22.11.2022.
//

import Foundation
import UIKit

class ProfileUserManager {
    var isLoading = false
    var isShowingRepositoriesView = false
    
    func getUser() {
        isLoading = true
        
        NetworkRequest
            .RequestType
            .getUser
            .networkRequest()?
            .start(responseType: User.self) { [weak self] result in
                switch result {
                case .success:
                    self?.isShowingRepositoriesView = true
                case .failure(let error):
                    print("Failed to get user, or there is no valid/active session: \(error)")
                }
                self?.isLoading = false
            }
    }
}
