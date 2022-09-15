//
//  UIImageView+Extension.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView{
    func makeCircle(cornerRadius: CGFloat){
        self.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.sizeToFit()
    }
    func setImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        self.kf.setImage(with: url)
    }
    

    
}
