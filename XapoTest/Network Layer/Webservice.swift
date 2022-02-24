//
//  Webservice.swift
//  XapoTest
//
//  Created by Olivier on 2/15/22.
//

import Foundation



typealias JSONdictionnary = [String:Any]

private let token = "token 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"
private let rootUrl = "https://api.github.com"

class Webservice {
    func loadRepos(language:String, query:String, sort:String, completion:@escaping ([Repo]) ->  ())  {
        
        let urlString = rootUrl+"/search/repositories?q=language:\(language)\(query)\(sort)&order=desc"


        print(urlString)
        
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
    
    func loadContributors(full_name: String, completion:@escaping ([Contributor]) ->  ())  {
        
        let url = URL(string: rootUrl+"/repos/\(full_name)/contributors")!
        print(url)
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
        
        func loadUser(username: String, completion:@escaping (User) ->  ())  {
            
            let url = URL(string: rootUrl+"/users/\(username)")!
            var request = URLRequest(url: url)
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

extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}