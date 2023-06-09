//
//  AlertShowable.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 6.06.2023.
//

import UIKit

protocol AlertShowable {
    func showAlert(message: String)
}

extension AlertShowable where Self: UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}
