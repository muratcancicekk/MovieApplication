//
//  MovieDetailVC.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 16.06.2023.
//

import UIKit

final class MovieDetailVC: BaseViewController<DetailViewModel, DetailsViewState> {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet  private var lblTitle: UILabel!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet weak private var lblIMBDScore: UILabel!
    @IBOutlet weak private var lblDate: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createProgressView()
        setupBackButton()
    }
    
    override func didStateChanged(oldState: DetailsViewState?, newState: DetailsViewState) {
        super.didStateChanged(oldState: oldState, newState: newState)
        switch newState {
        case .detailsDidLoad:
            setupUI()
            stopAndHideSpinner()
        }
    }

    func setupUI() {
        guard let model = viewModel.movieDetails else { return }
        movieImageView.setImage(with: model.posterPath?.setImageURL ?? "")
        lblTitle.text = model.title
        lblDescription.text = model.overview
        lblDate.text = model.releaseDate
        lblIMBDScore.text = model.voteAverage?.rounded(toPlaces: 1).toString
        setHeaderTitleView(title: model.title)
    }
}
extension MovieDetailVC {
    private func createProgressView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
