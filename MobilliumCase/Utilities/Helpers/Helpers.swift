//
//  Helpers.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 16.06.2023.
//

import Foundation

final class Helpers {
    static let shared = Helpers()
    func translateDateString(_ dateString: String, dateFormat: String = "dd/MM/yyyy - HH:mm" ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        if let date = dateFormatter.date(from: dateString) {
            let dateFormatterResult = DateFormatter()
            dateFormatterResult.dateFormat = dateFormat
            let result = dateFormatterResult.string(from: date)
            return result
        } else {
            return nil
        }
    }
}
