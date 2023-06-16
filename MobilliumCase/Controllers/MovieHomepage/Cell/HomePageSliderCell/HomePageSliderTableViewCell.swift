//
//  HomePageSliderTableViewCell.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.06.2023.
//

import UIKit

class HomePageSliderTableViewCell: UITableViewCell {
    private let layoutHorizantal: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let pageControl = UIPageControl()
    var movieTapped: ((Int) -> Void)?
    var timer: Timer?
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }

    var movies: [Movies]? {
        didSet {
            pageControl.numberOfPages = movies?.count ?? 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }
}
extension HomePageSliderTableViewCell: ConfigureCollectionView, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomePageSliderCollectionViewCell = collectionView.dequeue(for: indexPath)
        guard let movies = movies else { return UICollectionViewCell() }
        cell.setupUI(sliderModel: movies[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieID = movies?[indexPath.row].id else { return }
        movieTapped?(movieID)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
extension HomePageSliderTableViewCell {
    fileprivate func configureUI() {
        self.addSubviews(collectionView, pageControl)
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .red
        configureCollectionView()
        setSnapKit()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeCurrentImage), userInfo: nil, repeats: true)
    }
    @objc private func changeCurrentImage() {
        if (movies?.count ?? 0) != 0 {
            if currentPage < (movies?.count ?? 1) - 1 {
                currentPage = currentPage + 1
            } else {
                currentPage = 0
            }
            collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .right, animated: true)
        }
    }
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(cell: HomePageSliderCollectionViewCell.self)
    }
    private func setSnapKit() {
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(200)
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
}
