//
//  Double+Extension.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import Foundation
extension Double {
    
    var toString: String {
        return "\(self)"
    }
        func rounded(toPlaces places:Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return (self * divisor).rounded() / divisor
        }
    
}
