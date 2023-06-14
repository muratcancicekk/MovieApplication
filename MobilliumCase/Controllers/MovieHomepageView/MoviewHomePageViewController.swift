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
    private let layoutVertical: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let layoutHorizantal: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let homePageTableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var isRefleshing = false
    var homeSection = [HomePageSectionHelper]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(homePageTableView)
  
        collectionViewRegister()
        setSection()
        setSnapkit()
        reflessControl()
        setProgressView()

    }
    func setSection() {
        homeSection.append(HomePageSectionHelper(cell: .sliderCell))
        homeSection.append(HomePageSectionHelper(cell: .listCell))
    }
    override func didStateChanged(oldState: HomeViewState?, newState: HomeViewState) {
        super.didStateChanged(oldState: oldState, newState: newState)
        switch newState {
        case .homeDidLoad:
            homePageTableView.reloadData()
            stopAndHideSpinner()
        }
    }
    func setProgressView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func reflessControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        homePageTableView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: AnyObject) {
        self.isRefleshing = true
    }


    private func setSnapkit() {
        homePageTableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }

    private func collectionViewRegister() {
        homePageTableView.register(cell: HomePageCollectionViewCell.self)
        homePageTableView.register(cell: HomePageSliderTableViewCell.self)

        homePageTableView.dataSource = self
        homePageTableView.delegate = self
        homePageTableView.showsVerticalScrollIndicator = false
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
            let cell: HomePageSliderTableViewCell = homePageTableView.dequeueCell(for: indexPath)
            cell.movies = viewModel.sliderMoviesData
            return cell
        case .listCell:
            let cell: HomePageCollectionViewCell = homePageTableView.dequeueCell(for: indexPath)
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
}

