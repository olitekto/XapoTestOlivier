//
//  Webservice.swift
//  XapoTest
//
//  Created by Olivier on 2/15/22.
//

import Foundation
import AesEverywhere


typealias JSONdictionnary = [String:Any]

private let pkey =  "U2FsdGVkX1/q4NoG1ka/RW2ZXv50a7P6XB8ByK7IJ4pTelD/Q/F0ADNTetHFqghn1UEAUqLydLjcwXb7zmLMCg=="
private let skey  = "?hThXbR_?_3/te<j"
private let rootUrl = "https://api.github.com"

class Webservice {
    
    //--- Request for  Repos
    func loadRepos(language:String, query:String, sort:String, completion:@escaping ([Repo]) ->  ())  {
        
        let urlString = rootUrl+"/search/repositories?q=language:\(language)\(query)\(sort)&order=desc"
        print(urlString)
        let token = try! AES256.decrypt(input: pkey, passphrase: skey)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        print("-------->",url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            do {
                let json = try (JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary)!
                let arrOf = json["items"] as! [JSONdictionnary]
                DispatchQueue.main.async {
                    completion(arrOf.compactMap(Repo.init))
                }
                
            } catch{
                print(error)
            }
            
        }.resume()
        
        
    }
    
    //--- Request for  contributors
    func loadContributors(full_name: String, completion:@escaping ([Contributor]) ->  ())  {
        
        let url = URL(string: rootUrl+"/repos/\(full_name)/contributors")!
        print(url)
        let token = try! AES256.decrypt(input: pkey, passphrase: skey)
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            do {
                let contributors = try (JSONSerialization.jsonObject(with: data!, options: []) as? [JSONdictionnary])!
                DispatchQueue.main.async {
                    completion(contributors.compactMap(Contributor.init))
                }
                
            } catch{
                print(error)
            }
            
        }.resume()
    }
    
    //--- Request for User
    func loadUser(username: String, completion:@escaping (User) ->  ())  {
        
        let url = URL(string: rootUrl+"/users/\(username)")!
        var request = URLRequest(url: url)
        let token = try! AES256.decrypt(input: pkey, passphrase: skey)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            do {
                let user = try (JSONSerialization.jsonObject(with: data!, options: []) as? JSONdictionnary)!
                DispatchQueue.main.async {
                    completion(User(dic: user))
                }
                
            } catch{
                print(error)
            }
            
        }.resume()
        
    }
}

