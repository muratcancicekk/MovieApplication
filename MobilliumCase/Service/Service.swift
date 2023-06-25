//
//  Service.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 6.06.2023.
//

import Foundation

final class Service {
    
    func getHomeSlider(page :Int = 1,
                       success: @escaping ((HomeListModel?) -> Void),
                       failure: @escaping ((CustomError) -> Void)) {
        Network.shared.request(urlType: .slider, page: page) {  (reponse : Result<HomeListModel, CustomError>) in
            switch reponse {
            case .success(let responce):
                success(responce)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getHomeList(page : Int = 1, success: @escaping ((HomeListModel?) -> Void), failure: @escaping ((CustomError) -> Void)) {
        Network.shared.request(urlType: .list, page: page) { (reponse : Result<HomeListModel, CustomError>) in
            switch reponse {
            case .success(let responce):
                success(responce)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getMovieDetail(movieId :Int = 550, success: @escaping ((MovieDetailModel?) -> Void), failure: @escaping ((CustomError) -> Void)){
        Network.shared.request(urlType: .detail, page: movieId) { (reponse : Result<MovieDetailModel, CustomError>) in
            switch reponse {
            case .success(let responce):
               success(responce)
            case .failure(let error):
                failure(error)
            }
        }
    }}
