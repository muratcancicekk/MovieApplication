//
//  HomeViewModel.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation

enum HomeViewState {
    case homeDidLoad
}
class HomeViewModel: BaseViewModel  {
    lazy var service = Service()
    var sliderMoviesData = [Movies]()
    var listMoviesData = [Movies]()
    var listIndex = 1

    override func start() {
       // getSliderMovies()
       // getMoviesList()
       fetchDataWithDispatchGroup()
    }
    func getSliderMovies(pageNumber: Int = 1, completion: @escaping () -> Void = {}) {
        service.getHomeSlider(page: pageNumber) { [weak self] sliderMovies in
            if let sliderMovies = sliderMovies?.results {
                self?.sliderMoviesData = sliderMovies
                completion()
            }
        } failure: { [weak self] error in
            self?.handleError(error: error)
        }
    }

    func getMoviesList(page: Int = 1, completion: @escaping () -> Void = {}) {
        service.getHomeList { [weak self] listMovies in
            if let listMovies = listMovies?.results {
                self?.listMoviesData = listMovies
                completion()
            }
        } failure: { [weak self] error in
            self?.handleError(error: error)
        }
    }

    func fetchDataWithDispatchGroup() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        getSliderMovies(pageNumber: 1) {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getMoviesList(page: 1) {
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.changeState(to: HomeViewState.homeDidLoad)
        }
    }
}
