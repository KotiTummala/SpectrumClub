//
//  MembersViewController.swift
//  SpectrumClub
//
//  Created by Koti Tummala on 30/12/19.
//  Copyright © 2019 Koteswar_Rao. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var members: [Member]!
    private var filteredMembers: [Member]!
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak private var tableView: UITableView!
    
    var selectedSortOptions = (option: "Name", isForAscending: true)

    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        sort(option: "Name")
        setupSearchController()
    }

}

extension MembersViewController {
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
        searchController.searchBar.placeholder = "Search Members"
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
    private func filterContentForSearchText(_ searchText: String) {
        filteredMembers = members.filter { (member: Member) -> Bool in
            return member.name!.description.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
    
    //MARK:- Sort Functionality
    
    @IBAction private func sortButtonClicked(_ sender: UIBarButtonItem) {
        showSortOptionsVC()
    }
    /**
    
     Helper function to ahow the sort options VC
     
    - parameters:
       - nil
    - returns:
        -nil
     ---
    - Author:
       Koti Tummala
    */
    private func showSortOptionsVC() {
        if let vc = storyboard?.instantiateViewController(identifier: "SortOptionsViewController") as? SortOptionsViewController {
            vc.selectedOptions = selectedSortOptions
            vc.onCloseSelected = {[unowned self] in
                self.dismiss(animated: true, completion: nil)
            }
            vc.onMenuOptionClicked = {[unowned self] option, isForAsc in
                self.selectedSortOptions.option = option
                self.selectedSortOptions.isForAscending = isForAsc
                self.sort(option: option, isForAscending: isForAsc)
                self.dismiss(animated: false, completion: nil)
            }
            present(vc, animated: false, completion: nil)
        }
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
    private func sort(option: String, isForAscending: Bool = true) {
        if option == "Name" {
            if isForAscending {
                members.sort(by: { $0.name!.description < $1.name!.description })
            } else {
                members.sort(by: { $0.name!.description > $1.name!.description })
            }
        } else if option == "Age" {
            if isForAscending {
                members.sort(by: { $0.age! < $1.age! })
            } else {
                members.sort(by: { $0.age! > $1.age! })
            }
        } else {
            members = members!
                .sorted(by:
                    Member.nameCompare,        //--> Name
                    Member.ageCompare         //-->Age#
            )
        }
        reloadTable()
    }
    
    //Helper function to reload the table from Main thread.
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MembersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        let member = (isFiltering) ? self.filteredMembers[indexPath.row]: self.members[indexPath.row]
        cell.setData(member: member)
        cell.onFavoriteClicked = {[unowned self] selectedCell in
            if let selectedIndexPath = self.tableView.indexPath(for: selectedCell) {
                let member = (self.isFiltering) ? self.filteredMembers[selectedIndexPath.row]: self.members[selectedIndexPath.row]
                member.isFavorite = !member.isFavorite
                self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFiltering {
            if filteredMembers.count > 0 {
                return filteredMembers.count
            } else {
                return 0
            }
        } else {
            if let dataSource = members, dataSource.count > 0 {
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

extension MembersViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

class MemberCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    @IBOutlet private weak var favoriteButton: UIButton!
    
    var onFavoriteClicked: ((MemberCell)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(member: Member) {
        if let name = member.name?.description {
            nameLabel.text = "Name : \(name)"
        } else {
            nameLabel.text = "Name : N/A"
        }
        
        if let age = member.age {
            ageLabel.text = "Age : \(age)"
        } else {
            ageLabel.text = "Age : N/A"
        }
        
        if let phone = member.phone {
            phoneLabel.text = "Phone : \(phone)"
        } else {
            phoneLabel.text = "Phone : N/A"
        }
        
        if let email = member.email {
            emailLabel.text = "Email : \(email)"
        } else {
            emailLabel.text = "Email : N/A"
        }
        let imageName = member.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction private func favoriteButtonClicked(_ sender: UIButton) {
        if let favoriteClicked = onFavoriteClicked {
            favoriteClicked(self)
        }
    }
}
