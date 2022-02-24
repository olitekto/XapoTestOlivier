//
//  ContributorsListViewModel.swift
//  XapoTest
//
//  Created by Olivier on 2/16/22.
//

import Foundation


class ContributorsListViewModel {
    
    var contributors:[ContributorViewModel] = [ContributorViewModel]()
    
    func populateContributors(_ contributors :[Contributor]) {
        self.contributors = contributors.map(ContributorViewModel.init)
   }
    
}

class ContributorViewModel {
    
    // parameters
    var login:String!
    var avatar_url:String!
    var contributions:Int!
    
    init(contributor:Contributor) {
        self.login = contributor.login
        self.avatar_url = contributor.avatar_url
        self.contributions = contributor.contributions
    }
}
