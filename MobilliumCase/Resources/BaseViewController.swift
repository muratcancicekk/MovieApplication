//
//  BaseViewController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 6.06.2023.
//

import UIKit
import Combine

class BaseViewController<T: BaseViewModel, S>: UIViewController, AlertShowable {
    let child = SpinnerViewController()
    var viewModel: T!
    var navButtonTapped: (() -> Void)?

    var cancellables: Set<AnyCancellable> = []

    init(viewModel: T) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.didStateChanged = { [weak self] o, n in
            DispatchQueue.main.async { [weak self] in
                self?.didStateChanged(oldState: o as? S, newState: n as! S)
            }
        }
        self.viewModel.errorMessageHandler = { message in
            DispatchQueue.main.async {
                self.showAlert(message: message)
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        self.bind()
    }

    func bind() {}

    func didStateChanged(oldState: S?, newState: S) {}

    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    func makePush(toView: UIViewController) {
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
