//
//  Contributor.swift
//  XapoTest
//
//  Created by Olivier on 2/16/22.
//

import Foundation

class Contributor {
    
    // parameters
    var login:String!
    var avatar_url:String!
    var contributions:Int!

    
    // constructor
    init(dic: JSONdictionnary) {
        
        guard let login = dic["login"] as? String,  let avatar_url = dic["avatar_url"] as? String, let contributions = dic["contributions"] as? Int else {
            return
        }
        
        self.login = login
        self.avatar_url = avatar_url
        self.contributions = contributions

    }
}
