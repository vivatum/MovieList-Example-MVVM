//
//  UIImgeViewExtension.swift
//  MovieList
//
//  Created by Vivatum on 17/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit
import CocoaLumberjack

extension UIImageView {
    
    
    func setupImageByPath(_ path: String?) {
        
        guard let pathString = path else {
            self.setupPosterPlaceholder()
            return
        }
        
        guard let url = URLFactory.posterRequestURL(pathString) else {
            DDLogError("Can't get poster URL")
            self.setupPosterPlaceholder()
            return
        }
        
        ImageLoader.shared.getImageData(url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            case .failure(let error):
                self.setupPosterPlaceholder()
                DDLogError("Can't get contact image data: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupPosterPlaceholder() {
        DispatchQueue.main.async {
            if let placeholderImage = UIImage(named: "posterPlaceholder") {
                self.image = placeholderImage
            }
        }
    }
}
