//
//  RepoDetailsViewController.swift
//  XapoTest
//
//  Created by Olivier on 2/22/22.
//

import UIKit

class RepoDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var repoViewModel:RepoViewModel!

    @IBOutlet weak var visibilityBox: UIView!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var branchBox: UIView!
    @IBOutlet weak var repoBranchLabel: UILabel!
    @IBOutlet weak var repoFullNameLbl: UILabel!
    @IBOutlet weak var repoOwnerContainer: UIView!
    @IBOutlet weak var repoOwnerAvatarImg: UIImageView!
    @IBOutlet weak var repoOwnerNameLabel: UILabel!
    @IBOutlet weak var repoOwnerLocationLabel: UILabel!
    @IBOutlet weak var repoOwnerfollowers: UILabel!
    @IBOutlet weak var repoOwnerfollowings: UILabel!
    @IBOutlet weak var repoOwnerBio: UILabel!
    @IBOutlet weak var repoContributorsCountBox: UIView!
    @IBOutlet weak var repoContributorsCountLabel: UILabel!
    
    @IBOutlet weak var repoWatchersLabel: UILabel!
    @IBOutlet weak var repoForksLabel: UILabel!
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var repoLastUpdateDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var userViewModel:UserViewModel!
    private var contributorListViewModel:ContributorsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI(repoVM: repoViewModel)
        contributorListViewModel = ContributorsListViewModel()
        print(repoViewModel.full_name)
        Webservice().loadContributors(full_name: repoViewModel.full_name) { contributor in

            self.contributorListViewModel.populateContributors(contributor)
            self.collectionView.reloadData()
        }
    }
    
    
    func configureUI(repoVM: RepoViewModel){
        repoFullNameLbl.text = repoVM.full_name.capitalized
        repoBranchLabel.text = repoVM.default_branch.capitalized
        branchBox.layer.borderColor = UIColor.lightGray.cgColor
        branchBox.layer.borderWidth = 1.0
        
        visibilityLabel.text = repoVM.visibility.capitalized
        visibilityBox.layer.borderColor = UIColor.lightGray.cgColor
        visibilityBox.layer.borderWidth = 1.0
        
        repoOwnerAvatarImg.sd_setImage(with: URL(string: repoVM.owner.avatar_url), placeholderImage: UIImage(named: "avatar.png"))
        repoOwnerNameLabel.text = repoVM.owner.login.capitalized
        repoForksLabel.text = formatNumber(repoVM.forks) + " forks"
        repoWatchersLabel.text = formatNumber(repoVM.watchers) + " watchers"
        repoStarsLabel.text = formatNumber(repoVM.stars) + " stars"
        repoDescriptionLabel.text = repoVM.desc
        repoLanguage.text = repoVM.language.capitalized
        repoLastUpdateDateLabel.text = "Last update: " + utcToLocal(dateStr: repoVM.updated_at)!
        
        repoOwnerContainer.layer.borderColor = UIColor.lightGray.cgColor
        repoOwnerContainer.layer.borderWidth = 1.0
        
        repoContributorsCountBox.layer.borderColor = UIColor.lightGray.cgColor
        repoContributorsCountBox.layer.borderWidth = 1.0
        
        
        //load data
        Webservice().loadUser(username:(repoVM.owner.login)!) { user in
            self.userViewModel = UserViewModel(user: user)
            DispatchQueue.main.async {
                //self.contributorName.text = user.name
                self.repoOwnerLocationLabel.text = user.location.isEmpty == true ? "Unknown" : user.location
                self.repoOwnerfollowers.text  = formatNumber(user.followers)
                self.repoOwnerfollowings.text = formatNumber(user.following)
                self.repoOwnerBio.text = user.bio
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        repoContributorsCountLabel.text = String(contributorListViewModel.contributors.count)
        return contributorListViewModel.contributors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contributorCell2", for: indexPath) as! ContributorCell
        cell.contributorAvatarImg.sd_setImage(with: URL(string: contributorListViewModel.contributors[indexPath.row].avatar_url), placeholderImage: UIImage(named: "avatar.png"))
        cell.contributorAvatarImg.layer.borderColor = UIColor.white.cgColor
        cell.contributorAvatarImg.layer.borderWidth = 3.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contributorViewModel = contributorListViewModel.contributors[indexPath.row]
        // open modal and pass contributorViewModel
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ContributorModal") as? ContributorModal else{
            fatalError("Could not find vc")
        }
        controller.modalTransitionStyle = .crossDissolve
        controller.contributorViewModel = contributorViewModel
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
