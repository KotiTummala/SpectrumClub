//
//  ProgressHUD.swift
//  SpectrumClub
//
//  Created by Koteswar_Rao on 30/12/19.
//  Copyright © 2019 Koteswar_Rao. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    var  message = String(){
        
        didSet{
            
            UIMessageLabel?.text = message
        }
    }
    private var UIMessageLabel:UILabel?
    
    
    func prepareUI() -> Void {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        frame = (UIApplication.shared.keyWindow?.frame)!
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let hud = UIView()
        self .addSubview(hud)
        hud.backgroundColor = UIColor.white
        hud.layer.cornerRadius = 10.0
        hud.layer.borderWidth = 2.0
        hud.layer.borderColor = UIColor.clear.cgColor
        
        let width:CGFloat = 300.0 as CGFloat
        
        let height = 100 as CGFloat
        
        hud.frame = CGRect(x:(self.bounds.width-width)/2,y:(self.bounds.height-height)/2,width:width,height:height)
        
        UIMessageLabel = UILabel()
        UIMessageLabel?.backgroundColor = UIColor.clear
        UIMessageLabel?.frame = CGRect(x:0,y:0,width:width,height:height)
        UIMessageLabel?.textAlignment = .center
        UIMessageLabel?.textColor = UIColor.black
        
        hud.addSubview(UIMessageLabel!)
    }
    
    func hide() -> Void {
        
        DispatchQueue.main.async { [unowned self] in
            self.removeFromSuperview()
            
        }
    }
}
class ProgressHUD: NSObject {
    static  var progressView:ProgressView? = nil
    
    
  class func showHudWithMessage(message:String) -> Void {
        
        DispatchQueue.main.async {
        if (progressView == nil){
            
            progressView = ProgressView()
            
            progressView?.prepareUI()
            progressView?.message = message
            
        }
     }
    }
    
 class func dismissHud() -> Void {
        DispatchQueue.main.async {
            progressView?.hide()
            progressView = nil
        }

    }
}
