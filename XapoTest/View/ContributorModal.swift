//
//  ContributorModal.swift
//  XapoTest
//
//  Created by Olivier on 2/17/22.
//

import UIKit

class ContributorModal: UIViewController {
    
    @IBOutlet weak var contributorAvatarImg: UIImageView!
    @IBOutlet weak var contributorUsername: UILabel!
    @IBOutlet weak var contributorName: UILabel!
    @IBOutlet weak var contributorLocation: UILabel!
    @IBOutlet weak var contributorfollowers: UILabel!
    @IBOutlet weak var contributorfollowings: UILabel!
    @IBOutlet weak var contributorRepos: UILabel!
    
    @IBOutlet weak var contributorGists: UILabel!
    @IBOutlet weak var contributorBio: UILabel!
    
    var contributorViewModel:ContributorViewModel?
    
    private var userViewModel:UserViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(contributorViewModel!)
        
       
        //load data
        Webservice().loadUser(username:(contributorViewModel?.login)!) { user in
            self.userViewModel = UserViewModel(user: user)
            //print(user.name)
            DispatchQueue.main.async {
                self.contributorName.text = user.name
                self.contributorLocation.text = user.location.isEmpty == true ? "Unknown" : user.location
                self.contributorfollowers.text  = formatNumber(user.followers)
                self.contributorfollowings.text = formatNumber(user.following)
                self.contributorRepos.text = String(user.public_repos)
                self.contributorGists.text = String(user.public_gists)
                self.contributorBio.text = user.bio
            }
            
        }
        
        // gesture to dismiss modal
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.dissmissAction))
        self.view.addGestureRecognizer(gesture)
    }
    
    // dismiss function
    @objc func dissmissAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureUI(_ vm:ContributorViewModel){
        contributorAvatarImg.sd_setImage(with: URL(string: vm.avatar_url), placeholderImage: UIImage(named: "avatar.png"))
        contributorUsername.text = vm.login.capitalized
    }

}
