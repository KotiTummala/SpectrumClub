//
//  SortOptionsViewController.swift
//  SpectrumClub
//
//  Created by Koteswar_Rao on 31/12/19.
//  Copyright © 2019 Koteswar_Rao. All rights reserved.
//

import UIKit

class SortOptionsViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var containerView: UIView!
    
    var onMenuOptionClicked: ((_ option: String, _ isForAscending: Bool) -> ())?
    var onCloseSelected : (() -> ())?

    var selectedOptions = (option: "Name", isForAscending: true)
    
    //Sort options to display options in actionsheet
    let sortOptions: [String] = ["Name", "Age", "Name & Age"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: .zero)
        let isForAsc = selectedOptions.isForAscending
        segmentedControl.selectedSegmentIndex = isForAsc ? 0 : 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if touch.view != containerView {
            if let onClose = onCloseSelected {
                onClose()
            }
        }
    }
}

extension SortOptionsViewController {
    @IBAction private func closeSelected(_ sender: UIButton) {
        if let onClose = onCloseSelected {
            onClose()
        }
    }
    
    @IBAction private func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedOptions.isForAscending = true
        } else {
            selectedOptions.isForAscending = false
        }
    }
}

extension SortOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let onMenu = onMenuOptionClicked {
            let option = sortOptions[indexPath.row]
            selectedOptions.option = option
            onMenu(option, selectedOptions.isForAscending)
        }
    }
}

extension SortOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortOptionCell", for: indexPath)
        let option = sortOptions[indexPath.row]
        cell.textLabel?.text = option
        if selectedOptions.option == option {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
