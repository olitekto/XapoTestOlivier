//
//  Repo.swift
//  XapoTest
//
//  Created by Olivier on 2/15/22.
//

import Foundation

// model for repository
class Repo {
    
    // parameters
    var name:String!
    var full_name:String!
    var desc:String!
    var forks:Int!
    var language:String!
    var watchers:Int!
    var default_branch:String!
    var visibility:String!
    var stars:Int!
    var updated_at:String!
    var owner:Owner!
    
    // constructor
    init(dic: JSONdictionnary) {
        
        let name = dic["name"] as? String ?? ""
        let full_name = dic["full_name"] as? String ?? ""
        let desc = dic["description"] as? String ?? ""
        let watchers = dic["watchers"] as? Int ?? 0
        let forks = dic["forks"] as? Int ?? 0
        let stars = dic["stargazers_count"] as? Int ?? 0
        let language = dic["language"] as? String ?? ""
        let default_branch = dic["default_branch"] as? String ?? ""
        let visibility = dic["visibility"] as? String ?? ""
        let updated_at = dic["updated_at"] as? String ?? ""
        guard let owner = dic["owner"] as? NSDictionary else {return}
        
        self.name = name
        self.full_name = full_name
        self.desc = desc
        self.watchers = watchers
        self.forks = forks
        self.language = language
        self.default_branch = default_branch
        self.visibility = visibility
        self.stars = stars
        self.updated_at = updated_at
        self.owner = Owner.init(dic: owner)
    }
}
