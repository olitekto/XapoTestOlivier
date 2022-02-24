//
//  User.swift
//  XapoTest
//
//  Created by Olivier on 2/18/22.
//

import Foundation

class User {
    
    // parameters
    var login:String!
    var avatar_url:String!
    var bio:String!
    var name:String!
    var company:String!
    var location:String!
    var public_repos:Int!
    var public_gists:Int!
    var followers:Int!
    var following:Int!

    
    // constructor
    init(dic: JSONdictionnary) {
      
        guard let login = dic["login"] as? String else {
            print("pb on login")
            return
            
        }
        
        let bio = dic["bio"] as? String ?? ""
        let name = dic["name"] as? String ?? ""
        let avatar_url = dic["avatar_url"] as? String ?? ""
        let company = dic["company"] as? String ?? ""
        let location = dic["location"] as? String ?? ""
        guard let public_repos = dic["public_repos"] as? Int else {return}
        guard let public_gists = dic["public_gists"] as? Int else {return}
        guard let followers = dic["followers"] as? Int else {return}
        guard let following = dic["following"] as? Int else {return}
        

        self.login = login
        self.avatar_url = avatar_url
        self.bio = bio
        self.name = name
        self.company = company
        self.location = location
        self.public_repos = public_repos
        self.public_gists = public_gists
        self.followers = followers
        self.following = following

    }
}
