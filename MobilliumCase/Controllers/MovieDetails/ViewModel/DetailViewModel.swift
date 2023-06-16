//
//  DetailViewModel.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation

struct DetailsViewData {
    let id: Int
}

enum DetailsViewState {
    case detailsDidLoad
}

final class DetailViewModel: BaseViewModel {
    lazy var service = Service()
    var movieDetails: MovieDetailModel?
    var id: Int
    
    init(viewData: DetailsViewData) {
        self.id = viewData.id
    }
    
    override func start() {
        getMovieDetails()
    }
    
    func getMovieDetails() {
        service.getMovieDetail(movieId: id) { [weak self] movieDetails in
            guard let self = self else { return }
            
            if let movieDetails = movieDetails {
                self.movieDetails = movieDetails
                self.changeState(to: DetailsViewState.detailsDidLoad)
            }
            
        } failure: { [weak self] error in
            self?.handleError(error: error)
        }
    }
}
