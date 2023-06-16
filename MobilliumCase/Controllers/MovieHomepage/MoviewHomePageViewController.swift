//
//  MoviewHomePageViewController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import UIKit
enum HomePageCellEnum {
    case sliderCell
    case listCell
}

struct HomePageSectionHelper {
    let cell: HomePageCellEnum
}

class MoviewHomePageViewController: BaseViewController<HomeViewModel, HomeViewState> {
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    var homeSection = [HomePageSectionHelper]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func didStateChanged(oldState: HomeViewState?, newState: HomeViewState) {
        super.didStateChanged(oldState: oldState, newState: newState)
        switch newState {
        case .homeDidLoad:
            tableView.reloadData()
            stopAndHideSpinner()
        case .openDetail(let movieID):
            let detailsViewData = DetailsViewData(id: movieID)
            let detailsVC = MovieDetailVC(viewModel: DetailViewModel(viewData: detailsViewData))
            makePush(toView: detailsVC)
        }
    }
}
extension MoviewHomePageViewController: ConfigureTableView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let homeSection = homeSection[section].cell
        switch homeSection {
        case .sliderCell:
            return 1
        case .listCell:
            return viewModel.listMoviesData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeSection = homeSection[indexPath.section].cell
        switch homeSection {
        case .sliderCell:
            let cell: HomePageSliderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.movies = viewModel.sliderMoviesData
            cell.movieTapped = { [weak self] movieID in
                guard let self = self else { return }
                self.viewModel.openDetails(movieID: movieID)
            }
            return cell
        case .listCell:
            let cell: HomePageCollectionViewCell = tableView.dequeueCell(for: indexPath)
            let listMovie = viewModel.listMoviesData[indexPath.row]
            cell.configure(model: listMovie)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let homeSection = homeSection[indexPath.section].cell
        switch homeSection {
        case .sliderCell:
            return 250
        case .listCell:
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.listMoviesData.count - 1 {
            viewModel.getMoviesList()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movieID = viewModel.listMoviesData[indexPath.row].id else { return  }
        let detailsViewData = DetailsViewData(id: movieID)
        let detailsVC = MovieDetailVC(viewModel: DetailViewModel(viewData: detailsViewData))
        makePush(toView: detailsVC)
    }
}
extension MoviewHomePageViewController {
    
    fileprivate func configureUI() {
        view.addSubviews(tableView)
        setHeaderTitleView(title: Constants.appName)
        tableViewRegister()
        setSnapkit()
        reflessControl()
        setProgressView()
    }
    
    private func setSnapkit() {
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }

    private func tableViewRegister() {
        tableView.register(cell: HomePageCollectionViewCell.self)
        tableView.register(cell: HomePageSliderTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        setSection()
    }
    
    func setSection() {
        homeSection.append(HomePageSectionHelper(cell: .sliderCell))
        homeSection.append(HomePageSectionHelper(cell: .listCell))
    }
    
    func setProgressView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func reflessControl() {
        refreshControl.attributedTitle = NSAttributedString(string: Constants.pullToRef )
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc func refresh(_ sender: AnyObject) {
        do {
            try? viewModel.fetchDataWithDispatchGroup {
                self.tableView.refreshControl?.endRefreshing()
            }
        } catch {
            Logger.log(text: error.localizedDescription)
        }
    }
}
