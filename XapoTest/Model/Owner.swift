//
//  Owner.swift
//  XapoTest
//
//  Created by Olivier on 2/22/22.
//

import Foundation

class Owner {
    
    // parameters
    var login:String!
    var avatar_url:String!
    
    //  constructor
    init(dic:NSDictionary) {
        let login = dic["login"] as? String
        let avatar_url = dic["avatar_url"] as? String
        
        self.login = login
        self.avatar_url = avatar_url
    }
}
