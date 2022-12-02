//
//  DataProvider.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 30.11.2022.
//

import Foundation

protocol ProvideDataProtocol: AnyObject {
    func provideData() -> [Repository]
}

class DataBaseStrategy: ProvideDataProtocol {
    func provideData() -> [Repository] {
        
        return []
    }
}

class SearchBarStategy: ProvideDataProtocol {
    func provideData() -> [Repository] {
        
        return []
    }
    
    
}
