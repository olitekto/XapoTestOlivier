//
//  ReposViewController.swift
//  XapoTest
//
//  Created by Olivier on 2/15/22.
//

import UIKit
import SDWebImage
import RxSwift


class ReposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepoCellDelegate,NVActivityIndicatorViewable {
    
    //func from repo cell protocol to get contributor
    func didTblCellTapped(contributorViewModel: ContributorViewModel) {
        // open modal and pass contributorViewModel
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ContributorModal") as? ContributorModal else{
            fatalError("Could not find vc")
        }
        controller.modalTransitionStyle = .crossDissolve
        controller.contributorViewModel = contributorViewModel
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    private var repoListViewModel:ReposListViewModel!
    private var repos:[Repo]!
    
    //to search data
    private var searchTextArr = [String]()
    //to store filtered data
    private var filteredSearchTextArr:NSArray = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var toggleSearchBtn: UIButton!
    @IBOutlet weak var languageFilterBtn: UIView!
    @IBOutlet weak var languageFilterBtnTitle: UILabel!
    @IBOutlet weak var moreFiltersBtn: UIView!
    
    @IBOutlet weak var containerSearch: UIView!
    @IBOutlet weak var containerTop: UIView!
    @IBOutlet weak var searchText: UITextField!
    
    var isSearchFieldOpened = false
    
    // Rx  Swift
    let disposeBag = DisposeBag()
    
    var defaultLanguage = "Swift"
    var defaultQuery  = ""
    var defaultSort = "&sort=stars"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // load data and populate
        loadDataAndPopulate(defaultLanguage,defaultQuery,defaultSort)
        // set title for filter button
        languageFilterBtnTitle.text = defaultLanguage
        
        //setting delegate for search field
        searchText.delegate = self
        searchText.layer.borderColor = xapoLightGray.cgColor
        searchText.layer.borderWidth = 1.0
        searchText.layer.cornerRadius = 17.5
        
        // hide  seaarch  toggle btn by default
        toggleSearchBtn.isHidden = true
        
        // add action to language view
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openFilter))
        languageFilterBtn.addGestureRecognizer(gesture)
        
        //add action to filters
        let gesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openMoreFilters))
        moreFiltersBtn.addGestureRecognizer(gesture2)

        
    }
    
    func loadDataAndPopulate(_ language:String, _ query:String, _ sort:String) {
        
        //Instanciate viewmodel
        self.repoListViewModel = ReposListViewModel()
        self.searchTextArr.removeAll()
        
        startAnimating(CGSize(width: 40, height:40), message: "", type: NVActivityIndicatorType.ballBeat)
        // calling web service and populate data
        Webservice().loadRepos(language:language,query: query, sort: sort) { [self] repos in
            self.repos = repos
            self.repoListViewModel.populateRepos(repos)
            
            if  repoListViewModel.repos.count > 0 {
                // fill array for search purchpose
                for i in 0 ..< self.repoListViewModel.repos.count {
                  //  if (!(searchTextArr.contains(self.repoListViewModel.repos[i].full_name))){
                        self.searchTextArr.append(self.repoListViewModel.repos[i].full_name)
                 //   }
                    
                }
                
            } else {
                EmptyData(tableview: tableView, message: "No repo found")
            }
            self.tableView.reloadData()
            self.stopAnimating()
        }
    }
    
    // Open Filters VC
    @objc func openMoreFilters(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreFiltersVC") as! MoreFiltersViewController
        // RX listener to waiting for selected filers  and apply
        vc.selectedQuery.subscribe(onNext: { [weak self] settings in
            if settings.count > 0 {
                // update data
                self!.defaultQuery = settings[0] as! String
                self!.defaultSort = settings[1] as! String
                self!.loadDataAndPopulate(self!.defaultLanguage,self!.defaultQuery,self!.defaultSort)

            }
        }).disposed(by: disposeBag)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    // Open lang Filters Vc
    @objc func openFilter(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "filtervc") as! FilterViewController
        vc.selectedLanguage.subscribe(onNext: { [weak self] lang in
            // RX listener to waiting for selected language and apply
            if !lang.isEmpty {
                // update data
                self!.defaultLanguage = lang
                self!.loadDataAndPopulate(self!.defaultLanguage,self!.defaultQuery,self!.defaultSort)
                //update button title
                self?.languageFilterBtnTitle.text = lang
            }
        }).disposed(by: disposeBag)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // assigning number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repoListViewModel.repos.count
    }
    
    
    
    // assigning row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell",  for: indexPath) as! RepoCell
        let repoViewModel = self.repoListViewModel.repos[indexPath.row]
        cell.nameLabel.text = repoViewModel.full_name.capitalized
        cell.descriptionLabel.text = repoViewModel.desc.capitalized
        cell.languageLabel.text = repoViewModel.language.capitalized
        cell.watchersLabel.text = String(repoViewModel.stars)
        cell.forksLabel.text = String(repoViewModel.forks)
        //load contributors for each repo
        cell.contributorListViewModel = ContributorsListViewModel()
        //cell.collectionView.setContentOffset(cell.collectionView.contentOffset, animated:false)
       
      
            Webservice().loadContributors(full_name: repoViewModel.full_name) { contributor in
   
                    cell.contributorListViewModel.populateContributors(contributor)
                    
                    cell.collectionView.reloadData()
            }
        cell.actionTblDelagate = self
        return cell
    }
    
    // row selection action - go to repo details VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "repoDetail") as! RepoDetailsViewController
        vc.repoViewModel = self.repoListViewModel.repos[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // Close search bar on button taped
    @IBAction func toggleSearchAction(_ sender: Any) {
        if  isSearchFieldOpened {
            isSearchFieldOpened = false
            toggle(60)
            toggleSearchBtn.isHidden = true
        }
    }
    
    // Open search bar when touched
    @IBAction func searchTextFieldTouched(_ sender: Any) {
        if !isSearchFieldOpened {
            isSearchFieldOpened = true
            toggle(self.containerTop.frame.size.width - 52)
            toggleSearchBtn.isHidden = false
        }
    }
    
    // perfom  expand animation on search field
    func toggle(_ width: CGFloat) {
        
        UIView.animate(withDuration: 0.3) {
            self.widthConstraint.constant = width
            self.containerTop.layoutIfNeeded()
        }
     
    }
    
}

// functions for search
extension ReposViewController: UITextFieldDelegate {
    
    
    // function delegate  to detect text tapped in search field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string1 = string
        let string2 = searchText.text
        var finalString = ""
        if string.count > 0 { // if it was not delete character
            finalString = string2! + string1
        }
        else if string2!.count > 0{ // if it was a delete character
            
            finalString = String(string2!.dropLast())
        }
        // check if field is empty
        var isFieldEmpty = true
        let textFieldRange = NSRange(location: 0, length: textField.text?.count ?? 0)
        // check if search field is cleared
        if NSEqualRanges(range, textFieldRange) && string.count == 0 {
            isFieldEmpty = true
        } else {
            isFieldEmpty = false
        }
        // Filtering function with entered letters
        filterArray(searchString: finalString as NSString, isFieldEmpty: isFieldEmpty)
        return true
    }
    
    
    func filterArray(searchString:NSString, isFieldEmpty:Bool){
   
        // match with models
        let filteredRepos = repoListViewModel.searchRepos(repos,filteredSearchTextArr,searchString,searchTextArr)

        //populate initial data if field is empty else filtered data
        if isFieldEmpty == false {
            self.repoListViewModel.populateRepos(filteredRepos)
        } else {
            self.repoListViewModel.populateRepos(repos)
        }
        
        self.tableView.reloadData()
    }
}





// protocol for Repo view controller
protocol RepoCellDelegate {
    func didTblCellTapped(contributorViewModel: ContributorViewModel)
}

// Custom class for repo cell
class RepoCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, ContributorCellDelegate {
    
    // func that call function delegate delegatge VC and pass contributor VM
    func didColCellTapped(index: Int) {
        actionTblDelagate?.didTblCellTapped(contributorViewModel: contributorListViewModel.contributors[index])
    }
    
    var actionTblDelagate:RepoCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fullName:String!
    
    var contributorListViewModel:ContributorsListViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // delegate collection to  parent (tablev cell)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // set border on cell and radius
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = xapoLightGray.cgColor
        containerView.layer.cornerRadius = 10
    }
    
    //number of contributors items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contributorListViewModel.contributors.count
    }
    
    // assigning row
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contributorCell", for: indexPath) as! ContributorCell
        cell.contributorAvatarImg.sd_setImage(with: URL(string: contributorListViewModel.contributors[indexPath.row].avatar_url), placeholderImage: UIImage(named: "avatar.png"))
        cell.actionColDelegate = self
        return cell
    }
    
    // selection of contributor and delegate  cell who is going to delegate VC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ContributorCell
        // call function and parse correct index
        cell.actionColDelegate?.didColCellTapped(index: indexPath.row)
    }

}

// protocol for tableview cell
protocol ContributorCellDelegate {
    // pass index of contributor to tableview cell
    func didColCellTapped(index: Int)
}

// Custom class for contributor cell
class ContributorCell:UICollectionViewCell {
    @IBOutlet weak var contributorAvatarImg: UIImageView!
    // to delagate tableview cell
    var actionColDelegate: ContributorCellDelegate?
}


