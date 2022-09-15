//
//  BaseViewController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import UIKit

class BaseViewController: UIViewController {

    let child = SpinnerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func createAlert(title: String = "Warning",message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)

    }
    func makePush(toView: UIViewController)
    {
        self.navigationController?.pushViewController(toView, animated: true)
      
    }
    func makePop() {
        self.navigationController?.popViewController(animated: true)
    }
    func stopAndHideSpinner() {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }




}
