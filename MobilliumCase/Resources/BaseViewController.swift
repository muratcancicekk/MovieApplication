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
    func setupBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    func setHeaderTitleView(title: String? = "Title", image: String? = nil) {
        if image == nil {
            let titleLbl = UILabel()
            titleLbl.text = title
            titleLbl.textColor = .black
            titleLbl.font = UIFont.systemFont(ofSize: 24)
            titleLbl.adjustsFontSizeToFitWidth = true
            titleLbl.minimumScaleFactor = 0.5
            self.navigationItem.titleView = titleLbl
            return
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: image ?? "")
        imageView.contentMode = .center
        
        self.navigationItem.titleView = imageView
    }
}
