//
//  MoviewHomePageViewController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import UIKit
enum HomeViewCell {
    case slider
    case list
}
struct HomeViewSection {
    let cell: HomeViewCell
}

class MoviewHomePageViewController: BaseViewController<HomeViewModel, HomeViewState> {
    private let layoutVertical: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let layoutHorizantal: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let homePageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let homePageSliderCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let refreshControl = UIRefreshControl()
    var homeSection = [HomeViewSection]()
    private var timer: Timer?
    private var isRefleshing = false
    private var currentCellIndex = 0
    private let pageControl = UIPageControl()
    private var sliderIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func didStateChanged(oldState: HomeViewState?, newState: HomeViewState) {
        super.didStateChanged(oldState: oldState, newState: newState)
        switch newState {
        case .homeDidLoad:
            homePageCollectionView.reloadData()
            homePageSliderCollectionView.reloadData()
        }
    }
}
extension MoviewHomePageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return homeSection.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let homeSection = homeSection[section].cell
        switch homeSection {
        case .slider:
            return viewModel.sliderMoviesData.count
        case .list:
            return viewModel.listMoviesData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeSection = homeSection[indexPath.section].cell
        switch homeSection {
        case .slider:
            let cell: HomePageSliderCollectionViewCell = collectionView.dequeue(for: indexPath)
            let movie = viewModel.sliderMoviesData[indexPath.row]
            cell.configure(sliderModel: movie)
            return cell
        case .list:
            let cell: HomePageCollectionViewCell = collectionView.dequeue(for: indexPath)
            let listMovie = viewModel.listMoviesData[indexPath.row]
            cell.configure(model: listMovie)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let homeSection = homeSection[indexPath.section].cell
        switch homeSection {
        case .slider:
            return CGSize(width: UIScreen.width, height: UIScreen.height * 0.3)

        case .list:
            return CGSize(width: UIScreen.width, height: UIScreen.height * 0.15)

        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeSection = homeSection[indexPath.section].cell
        switch homeSection {
        case .slider:
            let choisonMovie = viewModel.sliderMoviesData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            vc.id = choisonMovie.id ?? 0
            makePush(toView: vc)
        case .list:
            let choisonMovie = viewModel.listMoviesData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            vc.id = choisonMovie.id ?? 0
            makePush(toView: vc)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == viewModel.listMoviesData.count - 3 {
            viewModel.listIndex += 1
            viewModel.getMoviesList(page: viewModel.listIndex)
          }
    }
}
extension MoviewHomePageViewController {
    fileprivate func configureUI() {
        homePageSliderCollectionView.isUserInteractionEnabled = true
        view.addSubviews(homePageCollectionView, homePageSliderCollectionView, pageControl)
        collectionViewRegister()
        setSnapkit()
        reflessControl()
        setProgressView()
    }
    private func collectionViewRegister() {
        layoutVertical.scrollDirection = UICollectionView.ScrollDirection.vertical
        layoutHorizantal.scrollDirection = UICollectionView.ScrollDirection.horizontal
        homePageCollectionView.setCollectionViewLayout(layoutVertical, animated: true)
        homePageSliderCollectionView.register(cell: HomePageSliderCollectionViewCell.self)
        homePageCollectionView.register(cell: HomePageCollectionViewCell.self)
        homePageCollectionView.dataSource = self
        homePageCollectionView.delegate = self
        homePageSliderCollectionView.setCollectionViewLayout(layoutHorizantal, animated: true)
        homePageSliderCollectionView.dataSource = self
        homePageSliderCollectionView.delegate = self
        homePageCollectionView.showsVerticalScrollIndicator = false
        homePageSliderCollectionView.isPagingEnabled = true
        homePageSliderCollectionView.showsHorizontalScrollIndicator = false
        setSection()
    }
    private func setSection() {
        homeSection.append(HomeViewSection(cell: .slider))
        homeSection.append(HomeViewSection(cell: .list))
    }
    private func applyStyle() {
        pageControl.numberOfPages = viewModel.sliderMoviesData.count
        pageControl.currentPageIndicatorTintColor = .white
    }
    private func setSnapkit() {
        homePageSliderCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: UIScreen.width, height: 350))
        }
        homePageCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(homePageSliderCollectionView.snp.bottom).offset(0)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(homePageSliderCollectionView.snp.bottom).offset(-70)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
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
        homePageCollectionView.addSubview(refreshControl)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        self.isRefleshing = true
          viewModel.getMoviesList()
    }
    
    @objc func moveToNextIndex() {
        if currentCellIndex < viewModel.sliderMoviesData.count - 1 {
            currentCellIndex += 1
        }
        else {
            currentCellIndex = 0
        }
        homePageSliderCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
    }
}


