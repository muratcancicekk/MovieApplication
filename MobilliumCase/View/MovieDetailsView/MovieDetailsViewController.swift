//
//  MovieDetailsViewController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import UIKit

class MovieDetailsViewController: BaseViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet weak private var lblIMBDScore: UILabel!
    @IBOutlet weak private var lblDate: UILabel!

    var id: Int?
    private let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.setBackBtn()
        viewModel.delegate = self
        if let id = id {
            viewModel.getMovieDetail(movieId: id)
        }
        else {
            makePop()
        }
        createProgressView()

    }

    private func createProgressView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    private func setBackBtn() {
        let backBtn = UIBarButtonItem()
        let image: UIImage = UIImage(named: "icon_back")!
        backBtn.image = image
        backBtn.action = #selector(self.makePop2)
        backBtn.target = self
        backBtn.tintColor = .black
        self.navigationItem.leftBarButtonItem = backBtn
    }
    @objc private func makePop2() {
        makePop()
    }
}


extension MovieDetailsViewController: DetailViewModelDelegate {
    func didFinishLoadingData(model: MovieDetailModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.imageView?.setImage(with: model.posterPath?.setImageURL ?? "")
            self.lblTitle.text = model.title
            self.lblDescription.text = model.overview
            self.lblDate.text = model.releaseDate
            self.lblIMBDScore.text = model.voteAverage?.rounded(toPlaces: 1).toString
            self.navigationItem.title = model.title
            self.stopAndHideSpinner()
        }
    }
    func didErrorLoadingData(error: CustomError) {
        Logger.log(type: .error, text: error.message)
    }


}
