//
//  ViewController.swift
//  SpectrumClub
//
//  Created by Koteswar_Rao on 30/12/19.
//  Copyright © 2019 Koteswar_Rao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var companies: Company!
    private var filteredCompanies = Company()
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    //Sort options to display options in actionsheet
    let sortOptions: [String] = ["Name Ascending", "Name Descending"]

    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: .zero)
        getCompanies()
        //Setup the SearchController UI
        setupSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let membersVC = segue.destination as? MembersViewController, let members = sender as? [Member] {
            membersVC.members = members
        }
    }
}

extension ViewController {
    //MARK:- API Helper
    /**
    
     Helper function to get the companies list from URL
     
    - parameters:
       - nil
    - returns:
        -nil
     ---
    - Author:
       Koti Tummala
    */
    private func getCompanies() {
        ProgressHUD.showHudWithMessage(message: "Loading...")
        WebService.shared.fetchCompanies(with: "Vk-LhK44U", result: { [unowned self] (result: Result<Company, WebService.APIServiceError>) in
            ProgressHUD.dismissHud()
            switch result {
                case .success(let company):
                    self.companies = company
                    self.sort()
                    self.reloadTable()
                case .failure(let error):
                    if error == .noNetwork { //Offline(No internet connection)
                        Alert.showInternetFailureAlert(on: self)
                    } else if error == .apiError { //Error while connecting to server
                        Alert.showConnectionFailureAlert(on: self)
                }
            }
        })
    }
    
    //MARK:- Search Functionality
    /**
    
     Helper function to set  the SearchController
     
    - parameters:
       - nil
    - returns:
        -nil
     ---
    - Author:
       Koti Tummala
    */
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Companies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /**
    
     Helper function to filter the companies based company name  search text
     
    - parameters:
       - searchText: String -  Text entered  in search bar
    - returns:
        -nil
     ---
    - Author:
       Koti Tummala
    */
    func filterContentForSearchText(_ searchText: String) {
        filteredCompanies = companies.filter { (company: CompanyElement) -> Bool in
            return company.company!.lowercased().contains(searchText.lowercased())
      }
      
      reloadTable()
    }
    
    //MARK:- Sort Functionality
    
    @IBAction private func sortButtonClicked(_ sender: UIBarButtonItem) {
        if let title = sender.title, title == "A-Z" {
            sender.title = "Z-A"
            sort(isForAscending: false)
        } else {
            sender.title = "A-Z"
            sort(isForAscending: true)
        }
        //showActionSheet(with: "Select", message: "Option to Sort")
    }
    /**
    
     Helper function to show the action sheet with sort options
     
    - parameters:
       - title: String value to show the title of the action sheet
       - message : String value to show the message of the action sheet
    - returns:
        -nil
     ---
    - Author:
       Koti Tummala
    */
    private func showActionSheet(with title: String, message: String) {
        //Intializing AlertController with style as ActionSheet
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for option in sortOptions { //Looping through the array of shapes to show the options in ActionSheet
            let action = addAlertAction(with: option, handler: { [weak self] action in
                guard let actionTitle = action.title else {
                    return
                }
                if actionTitle.contains("Ascending") {
                    self?.sort(isForAscending: true)
                } else {
                   self?.sort(isForAscending: false)
                }
            })
            alert.addAction(action)
        }

        if let presenter = alert.popoverPresentationController { //To show as Popover in iPads.
            presenter.barButtonItem = sortButton
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     Helper function to return the UIAlertAction
     ---
    - parameters:
       - title: String value to show the title of the UIAlertAction
       - handler : Closure to handle, when the each option selected from Actionsheet
    - returns:
       - UIAlertAction
     ---
    - Author:
       Koti Tummala
    */
    private func addAlertAction(with title: String, handler: @escaping ((UIAlertAction) -> ())) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default, handler: handler)
        return action
    }
    
    /**
     Helper function to sort the companies array on selection of the option from Actionsheet
     
    - parameters:
       - option: String value - selected sort option Actionsheet.
    
    - returns:
       - nil
     ---
    - Author:
       Koti Tummala
    */
    private func sort(isForAscending: Bool = true) {
        if isForAscending {
            companies.sort(by: { $0.company! < $1.company! })
            reloadTable()
        } else {
            companies.sort(by: { $0.company! > $1.company! })
            reloadTable()
        }
    }
    
    //Helper function to reload the table from Main thread.
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /**
     Helper function to update the company Status(Favorite/Follow)
     
    - parameters:
       - isForFavorite: Bool value - true means we are updating the favorite status, else updating the follow status of the company.
       - selectedCell: UITableViewCell - To get the selected company object to update
    
    - returns:
       - nil
     ---
    - Author:
       Koti Tummala
    */
    private func updateCompanyStatus(isForFavorite: Bool, selectedCell: CompanyCell) {
        if let selectedIndexPath = self.tableView.indexPath(for: selectedCell) {
            let company = (self.isFiltering) ? self.filteredCompanies[selectedIndexPath.row]: self.companies[selectedIndexPath.row]
            if isForFavorite {
                company.isFavorite = !company.isFavorite
            } else {
                company.isFollowing = !company.isFollowing
            }
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let company = (isFiltering) ? self.filteredCompanies[indexPath.row]: self.companies[indexPath.row]
        if let members = company.members, members.count > 0 {
            performSegue(withIdentifier: "membersSegue", sender: members)
        } else {
            
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        let company = (isFiltering) ? self.filteredCompanies[indexPath.row]: self.companies[indexPath.row]
        cell.setData(company: company)
        cell.onFavoriteClicked = { [unowned self] selectedCell in
            self.updateCompanyStatus(isForFavorite: true, selectedCell: selectedCell)
        }
        
        cell.onFollowClicked = { selectedCell in
           self.updateCompanyStatus(isForFavorite: false, selectedCell: selectedCell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if filteredCompanies.count > 0 {
                return filteredCompanies.count
            } else {
                return 0
            }
        } else {
            if let dataSource = companies, dataSource.count > 0 {
                return dataSource.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

class CompanyCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var websiteLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var companyLogoImageView: CachedImageView!
    
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var followButton: UIButton!
    
    var onFollowClicked: ((CompanyCell)->())?
    var onFavoriteClicked: ((CompanyCell)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(company: CompanyElement) {
        nameLabel.text = company.company
        websiteLabel.text = company.website
        descriptionLabel.text = company.about
        if let logo = company.logo {
            companyLogoImageView.loadImage(from: logo)
        } else {
            companyLogoImageView.image = UIImage(named: "")
        }
        var imageName = company.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        imageName = company.isFollowing ? "bookmark.fill" : "bookmark"
        followButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction private func favoriteButtonClicked(_ sender: UIButton) {
        if let favoriteClicked = onFavoriteClicked {
            favoriteClicked(self)
        }
    }
    
    @IBAction private func followButtonClicked(_ sender: UIButton) {
        if let followClicked = onFollowClicked {
            followClicked(self)
        }
    }
}
