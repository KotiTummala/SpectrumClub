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
    
    private var companyDataSource: Company!
    private var filterCompanyDataSource: Company!
    private var isSearchActive = false
    
    var searchButton:UIBarButtonItem?
    
    var clearSearchButton:UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: .zero)
        getCompanies()
    }
    
    private func getCompanies() {
        ProgressHUD.showHudWithMessage(message: "Loading...")
        WebService.shared.fetchCompanies(with: "Vk-LhK44U", result: { [unowned self] (result: Result<Company, WebService.APIServiceError>) in
            ProgressHUD.dismissHud()
            switch result {
                case .success(let company):
                    self.companyDataSource = company
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        })
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        let company = (isSearchActive) ? self.filterCompanyDataSource[indexPath.row]: self.companyDataSource[indexPath.row]
        cell.setData(company: company)
        cell.onFavoriteClicked = { selectedCell in
            
        }
        
        cell.onFollowClicked = { selectedCell in
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearchActive {
            if filterCompanyDataSource.count > 0 {
                return filterCompanyDataSource.count
            } else {
                return 0
            }
        } else {
            if let dataSource = companyDataSource, dataSource.count > 0 {
                return companyDataSource.count
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

class CompanyCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var websiteLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var companyLogoImageView: UIImageView!
    
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
