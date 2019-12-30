//
//  Alert.swift
//  SpectrumClub
//
//  Created by Koti Tummala on 30/12/19.
//  Copyright © 2019 Koteswar_Rao. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    static let internetAlertMessage = "Please check your internet connection and try again"
    static let internetAlertTitle = "Internet Failure"
    private static func showAlert(on vc:UIViewController,with title:String, message:String, completion: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            if let completionHandler = completion {
                completionHandler(action)
            }
        }))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    //Show Common Alert like internet failure
    static func showInternetFailureAlert(on vc:UIViewController){
        showAlert(on: vc, with: internetAlertTitle, message: internetAlertMessage, completion: nil)
    }
    
    //Show error while connecting to server
    static func showConnectionFailureAlert(on vc:UIViewController){
        showAlert(on: vc, with: "Error", message: "Could not connect to the server.", completion: nil)
    }
}

