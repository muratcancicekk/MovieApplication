//
//  String+Extension.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation
extension String {
    var setImageURL : String {
        return UrlParts.baseURLImage.rawValue + self
    }
    
}
