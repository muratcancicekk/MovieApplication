//
//  HomeViewModel.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation

enum HomeViewState {
    case homeDidLoad
    case openDetail(Int)
}
final class HomeViewModel: BaseViewModel  {
    lazy var service = Service()
    var sliderMoviesData = [Movies]()
    var listMoviesData = [Movies]()
    let paginationManager = PaginationManager()
    
    override func start() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        do {
            try? fetchDataWithDispatchGroup {
                dispatchGroup.leave()
            }
        } catch {
            Logger.log(text: error.localizedDescription)
        }
        
        dispatchGroup.notify(queue: .main) {
            self.changeState(to: HomeViewState.homeDidLoad)
        }
    }
    func getSliderMovies(completion: @escaping () -> Void = {}) {
        guard paginationManager.canLoadMore() else { return }
        paginationManager.startedLoading()
        
        service.getHomeSlider(page: paginationManager.pageNo) { [weak self] sliderMovies in
            guard let self = self else { return }
            
            if let sliderMovies = sliderMovies?.results {
                self.paginationManager.fetchedData(count: sliderMovies.count)
                self.sliderMoviesData.append(contentsOf: sliderMovies)
                completion()
            }
            
        } failure: { [weak self] error in
            self?.handleError(error: error)
        }
    }
    
    func getMoviesList(completion: @escaping () -> Void = {}) {
        guard paginationManager.canLoadMore() else { return }
        paginationManager.startedLoading()
        
        service.getHomeList(page: paginationManager.pageNo) { [weak self] listMovies in
            guard let self = self else { return }
            
            if let listMovies = listMovies?.results {
                self.paginationManager.fetchedData(count: listMovies.count)
                self.listMoviesData.append(contentsOf: listMovies)
                self.changeState(to: HomeViewState.homeDidLoad)
                completion()
            }
            
        } failure: { [weak self] error in
            self?.handleError(error: error)
        }
    }
    
    func fetchDataWithDispatchGroup(_ fetchSuccess: (() -> Void)? = nil) throws {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getSliderMovies() {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            dispatchGroup.enter()
            self.getMoviesList() {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            fetchSuccess?()
        }
    }
    
    func openDetails(movieID: Int) {
        self.changeState(to: HomeViewState.openDetail(movieID))
    }
}
