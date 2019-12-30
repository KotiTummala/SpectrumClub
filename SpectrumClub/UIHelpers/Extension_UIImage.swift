//
//  Extension_UIImage.swift
//  APIBackedApp
//
//  Created by Tim Beals on 2018-09-24.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    static func cacheImage(from urlString: String, completion: @escaping (UIImage?) -> ()) {
        WebService.shared.fetchImage(from: urlString, result: { (result: Result<UIImage, WebService.APIServiceError>) in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as AnyObject)
                    }
                    completion(image)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        })
    }
}
