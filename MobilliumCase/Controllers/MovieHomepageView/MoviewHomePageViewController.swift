//
//  MoviewHomePageViewController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import UIKit

class MoviewHomePageViewController: BaseViewController<HomeViewModel, HomeViewState> {
    private let layoutVertical: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let layoutHorizantal: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let homePageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let homePageSliderCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let refreshControl = UIRefreshControl()
    private var timer: Timer?
    private var isRefleshing = false
    private var currentCellIndex = 0
    private let pageControl = UIPageControl()
    private var sliderModel = [Movies]()
    private var listModel = [Movies]()
    private var sliderIndex = 1
    private var listIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        homePageSliderCollectionView.isUserInteractionEnabled = true
        view.addSubviews(homePageCollectionView, homePageSliderCollectionView, pageControl)
  
        collectionViewRegister()
        setSnapkit()
        reflessControl()
        setProgressView()

    }
    override func didStateChanged(oldState: HomeViewState?, newState: HomeViewState) {
        super.didStateChanged(oldState: oldState, newState: newState)
        switch newState {
        case .homeDidLoad:
            homePageCollectionView.reloadData()
            homePageSliderCollectionView.reloadData()
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
        homePageCollectionView.addSubview(refreshControl)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        self.isRefleshing = true
    }

    @objc func moveToNextIndex() {
        if currentCellIndex < sliderModel.count - 1 {
            currentCellIndex += 1
        }
        else {
            currentCellIndex = 0
        }

        homePageSliderCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.row == listModel.count - 3 {
            listIndex += 1
        }
    }

    private func applyStyle() {
        pageControl.numberOfPages = sliderModel.count
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

    private func collectionViewRegister() {
        layoutVertical.scrollDirection = UICollectionView.ScrollDirection.vertical
        layoutHorizantal.scrollDirection = UICollectionView.ScrollDirection.horizontal
        homePageCollectionView.setCollectionViewLayout(layoutVertical, animated: true)
        homePageCollectionView.register(cell: HomePageCollectionViewCell.self)
        homePageCollectionView.dataSource = self
        homePageCollectionView.delegate = self
        homePageSliderCollectionView.setCollectionViewLayout(layoutHorizantal, animated: true)
        homePageSliderCollectionView.register(cell: HomePageSliderCollectionViewCell.self)
        homePageSliderCollectionView.dataSource = self
        homePageSliderCollectionView.delegate = self
        homePageCollectionView.showsVerticalScrollIndicator = false
        homePageSliderCollectionView.isPagingEnabled = true
        homePageSliderCollectionView.showsHorizontalScrollIndicator = false
    }
}
extension MoviewHomePageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homePageSliderCollectionView {
            return sliderModel.count
        }
        else {
            return listModel.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == homePageSliderCollectionView {
            let cell: HomePageSliderCollectionViewCell = collectionView.dequeue(for: indexPath)
            let movie = sliderModel[indexPath.row]
            cell.configure(sliderModel: movie)

            return cell
        }
        else {
            let cell: HomePageCollectionViewCell = collectionView.dequeue(for: indexPath)
            let listMovie = listModel[indexPath.row]
            cell.configure(model: listMovie)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == homePageSliderCollectionView {
            return CGSize(width: UIScreen.width, height: UIScreen.height * 0.3)
        }
        else {
            return CGSize(width: UIScreen.width, height: UIScreen.height * 0.15)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homePageSliderCollectionView {
            let choisonMovie = sliderModel[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            vc.id = choisonMovie.id ?? 0
            makePush(toView: vc)
        }
        else {
            let choisonMovie = listModel[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            vc.id = choisonMovie.id ?? 0
            makePush(toView: vc)
        }
    }
}

