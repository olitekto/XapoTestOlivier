//
//  FilterViewController.swift
//  XapoTest
//
//  Created by Olivier on 2/22/22.
//

import UIKit
import RxSwift

class FilterViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    let dataccess = DataAccess()
    var languages = ["Java","Swift","Kotlin","Go","Python","PHP"]
    
    //Rx observable
    private let selectedLanguageVariable =  BehaviorSubject(value: "")
    var selectedLanguage:Observable<String> {
        return  selectedLanguageVariable
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.languages = dataccess.githubLanguages
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    // assigning row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell",  for: indexPath) as! FilterCell
        cell.languageNameLabel.text = languages[indexPath.row]
        
        return cell
    }
    
    // height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //  action on row selection / tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        selectedLanguageVariable.onNext(language)
        self.dismiss(animated: true, completion: nil)
    }
    
    // dismiss function of modal
    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

//UITableViewCell for language cell
class FilterCell: UITableViewCell {
    
    @IBOutlet weak var languageNameLabel: UILabel!
}
