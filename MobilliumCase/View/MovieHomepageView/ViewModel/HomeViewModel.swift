//
//  HomeViewModel.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation

protocol HomeViewModelDelegate : AnyObject {
    func didFinishLoadingSlider(model : MainModel)
    func didErrorLoadingSlider(error: CustomError)
    func didFinishLoadingList(model : MainModel)
    func didErrorLoadingList(error: CustomError)
}
class HomeViewModel  {
    var delegate : HomeViewModelDelegate?
    func getSlider(page :Int = 1){
        Network.shared.request(urlType: .slider, page: page) { [weak self](reponse : Result<MainModel, CustomError>) in
            guard let self = self else {return}
            switch reponse {
            case .success(let success):
                self.delegate?.didFinishLoadingSlider(model: success)
                print(success)
            case .failure(let failure):
                self.delegate?.didErrorLoadingSlider(error: failure)
            }
        }
    }
    func getList(page : Int = 1) {
        Network.shared.request(urlType: .list, page: page) { [weak self](reponse : Result<MainModel, CustomError>) in
            guard let self = self else {return}
            switch reponse {
            case .success(let success):
                self.delegate?.didFinishLoadingList(model: success)
            case .failure(let failure):
                self.delegate?.didErrorLoadingList(error: failure)
            }
        }
    }
    
}
