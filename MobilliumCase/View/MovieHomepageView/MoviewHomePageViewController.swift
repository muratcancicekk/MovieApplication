//
//  MoviewHomePageViewController.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import UIKit

class MoviewHomePageViewController: BaseViewController {
    private let layoutVertical: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let layoutHorizantal: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let homePageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let homePageSliderCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let refreshControl = UIRefreshControl()
    var timer: Timer?
    var isRefleshing = false
    var currentCellIndex = 0
    let pageControl = UIPageControl()
    let viewModel = HomeViewModel()
    var sliderModel = [Movies]()
    var listModel = [Movies]()
    var sliderIndex = 1
    var listIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        homePageSliderCollectionView.isUserInteractionEnabled = true
        view.addSubviews(homePageCollectionView, homePageSliderCollectionView, pageControl)
        viewModel.getSlider()
        viewModel.getList()
        collectionViewRegister()
        setSnapkit()
       
        reflessControl()
        setProgressView()
        
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
        viewModel.getList()
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
            viewModel.getList(page: listIndex)
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
        homePageCollectionView.register(UINib(nibName: "HomePageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomePageCell")
        homePageCollectionView.dataSource = self
        homePageCollectionView.delegate = self
        homePageSliderCollectionView.setCollectionViewLayout(layoutHorizantal, animated: true)
        homePageSliderCollectionView.register(UINib(nibName: "HomePageSliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomePageSliderCell")
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
            let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageSliderCell", for: indexPath) as! HomePageSliderCollectionViewCell
            let movie = sliderModel[indexPath.row]
            collection.configure(sliderModel: movie)

            return collection
        }
        else {
            let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCell", for: indexPath) as! HomePageCollectionViewCell
            let listMovie = listModel[indexPath.row]
            collection.configure(model: listMovie)

            return collection
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
extension MoviewHomePageViewController: HomeViewModelDelegate {
    func didFinishLoadingSlider(model: MainModel) {
        guard let model = model.results else {
            return
        }
        self.sliderModel.append(contentsOf: model)
        DispatchQueue.main.async {
            self.homePageSliderCollectionView.reloadData()
            self.startTimer()
            self.applyStyle()

        }
    }

    func didErrorLoadingSlider(error: CustomError) {
        self.createAlert(message: error.message)
    }

    func didFinishLoadingList(model: MainModel) {
        guard let model = model.results else {
            return
        }
        if self.isRefleshing {
            self.listModel = model
            DispatchQueue.main.async {
                self.homePageCollectionView.reloadData()
                self.refreshControl.endRefreshing()
                self.isRefleshing = false
            }
        }
        else {
            self.listModel.append(contentsOf: model)
            DispatchQueue.main.async {
                self.homePageCollectionView.reloadData()
                self.stopAndHideSpinner()
            }
        }
    }

    func didErrorLoadingList(error: CustomError) {
        self.createAlert(message: error.message)
    }
}

