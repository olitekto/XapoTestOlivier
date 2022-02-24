//
//  ReposListViewmodel.swift
//  XapoTest
//
//  Created by Olivier on 2/15/22.
//

import Foundation

// ViewModel for a the list of repos
class ReposListViewModel {
    
    var repos:[RepoViewModel] = [RepoViewModel]()

    func populateRepos(_ repos :[Repo]) {
         self.repos = repos.map(RepoViewModel.init)
    }
    
    
    func searchRepos(_ repos :[Repo], _ filteredSearchTextArr1:NSArray, _
                        searchString:NSString, _ searchTextArr:[String]) -> [Repo] {
        var filteredSearchTextArr = filteredSearchTextArr1
        // we will use NSPredicate to find the string in array
        // This will give all element of array which contains search string
        let predicate = NSPredicate(format: "SELF contains[c] %@",searchString)
        filteredSearchTextArr = (searchTextArr as NSArray).filtered(using: predicate) as NSArray
        print(filteredSearchTextArr)
        var filteredRepos:[Repo] = []
        for i in 0 ..< repos.count {
            for y in 0 ..< filteredSearchTextArr.count {
                if repos[i].full_name == filteredSearchTextArr[y] as? String{
                    filteredRepos.append(repos[i])
                }
            }
        }
        return filteredRepos
    }
    
}

// ViewModel for a single repo
class RepoViewModel {
    
    //parameters
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
    
    //initialize with repo model
    init(repo: Repo) {
        self.name = repo.name
        self.full_name = repo.full_name
        self.desc = repo.desc
        self.language = repo.language
        self.forks = repo.forks
        self.watchers = repo.watchers
        self.default_branch  = repo.default_branch
        self.visibility = repo.visibility
        self.stars  = repo.stars
        self.owner = repo.owner
        self.updated_at = repo.updated_at

    }
}
