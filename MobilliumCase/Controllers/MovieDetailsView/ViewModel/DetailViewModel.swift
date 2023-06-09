//
//  DetailViewModel.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation
protocol DetailViewModelDelegate : AnyObject {
    func didFinishLoadingData(model : MovieDetailModel)
    func didErrorLoadingData(error: CustomError)
}
enum DetailsViewState {
    
}
class DetailViewModel: BaseViewModel {
    var delegate : DetailViewModelDelegate?
    
    func getMovieDetail(movieId :Int = 550){
        Network.shared.request(urlType: .detail, page: movieId) { [weak self](reponse : Result<MovieDetailModel, CustomError>) in
            guard let self = self else {return}
            switch reponse {
            case .success(let success):
                self.delegate?.didFinishLoadingData(model: success)
            case .failure(let failure):
                self.delegate?.didErrorLoadingData(error: failure)
            }
        }
    }
}
