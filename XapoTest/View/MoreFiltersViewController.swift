//
//  MoreFiltersViewController.swift
//  XapoTest
//
//  Created by Olivier on 2/23/22.
//

import UIKit
import RxSwift

class MoreFiltersViewController: UIViewController {
    
    
    @IBOutlet weak var switchStars: UISwitch!
    @IBOutlet weak var switchForks: UISwitch!
    @IBOutlet weak var swtchUpdates: UISwitch!
    @IBOutlet weak var switchIssues: UISwitch!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var repositorySizeLabel: UILabel!
    
    var sort = "&sort=watchers"
    var followers = ""
    var repoSize = ""
    
    
    //Rx observable
    private let selectedQueriesVariable =  BehaviorSubject(value: [])
    var selectedQuery:Observable<Array<Any>> {
        return  selectedQueriesVariable
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.tag == 1  {
            if sender.isOn {
                switchForks.isOn = false
                swtchUpdates.isOn  = false
                switchIssues.isOn = false
                sort = "&sort=stars"
            } else {
                sort = "&sort=watchers"
            }
        }
        if sender.tag == 2  {
            if sender.isOn {
                switchStars.isOn = false
                swtchUpdates.isOn  = false
                switchIssues.isOn = false
                sort = "&sort=forks"
            }else {
                sort = "&sort=watchers"
            }
        }
        if sender.tag == 3  {
            if sender.isOn {
                switchStars.isOn = false
                switchForks.isOn  = false
                switchIssues.isOn = false
                sort = "&sort=updated"
            }else {
                sort = "&sort=watchers"
            }
        }
        if sender.tag == 4  {
            if sender.isOn {
                switchForks.isOn = false
                swtchUpdates.isOn  = false
                switchStars.isOn = false
                sort = "&sort=help-wanted-issues"
            }else {
                sort = "&sort=watchers"
            }
        }
        
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        
        //followers
        if  sender.tag == 1  {
            let value = Int(sender.value * 1000)
            if value == 0 {
                followersLabel.text  = "Followers (not applied)"
                followers = ""
            }  else {
                followersLabel.text  = "More than \(formatNumber(value)) followers"
                followers = "+followers:%3E=\(value)"
            }
            
        }
        
        // repodsitory size
        if  sender.tag == 2  {
            let value = Int(sender.value * 1000)
            if value == 0 {
                repositorySizeLabel.text  = "Repo size (not applied)"
                repoSize = ""
            }  else {
                repositorySizeLabel.text  = "Size less than \(formatNumber(value))"
                repoSize = "+size:%3C\(value)"
            }
            
        }
        
    }
    
    @IBAction func applyAction(_ sender: Any) {

        selectedQueriesVariable.onNext([followers+repoSize,sort])
        self.dismiss(animated: true, completion: nil)
    }
    
    // dismiss function of modal
    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
