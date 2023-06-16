//
//  BaseNavigationController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 9.06.2023.
//

import UIKit

class BaseNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Status bar color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        navigationBar.tintColor = .white
    }
}
