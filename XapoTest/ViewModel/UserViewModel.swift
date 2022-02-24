//
//  UserViewModel.swift
//  XapoTest
//
//  Created by Olivier on 2/18/22.
//

import Foundation

class UserViewModel {
    
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
    
    init(user:User) {
        self.login = user.login
        self.avatar_url = user.avatar_url
        self.bio = user.bio
        self.name = user.name
        self.company = user.company
        self.location = user.location
        self.public_repos = user.public_repos
        self.public_gists = user.public_gists
        self.followers = user.followers
        self.following = user.following
    }
}
