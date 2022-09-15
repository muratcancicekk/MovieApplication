//
//  HomePageSliderCollectionViewCell.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import UIKit
import SnapKit

class HomePageSliderCollectionViewCell: UICollectionViewCell {
    let view = UIView()
    let image = UIImageView()
    let headerLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(image)
        image.addSubviews(view,headerLabel,subtitleLabel)
        applyStyle()
        setSnapkit()
        // Initialization code
    }
    private func applyStyle(){
        view.backgroundColor = .black.withAlphaComponent(0.3)
        image.image = UIImage(named: "dumydata")
        image.contentMode = .scaleToFill
        headerLabel.styleLabel(title: "Moonrise Kingdom (2012)", textAlignment: .left, color: .white, fontSize: UIFont.systemFont(ofSize: 20, weight: .bold))
        subtitleLabel.styleLabel(title: "A pair of young lovers flee their New England town, which causes a local search party to fan out to find them.", textAlignment: .left, color: .white, fontSize: UIFont.systemFont(ofSize: 12, weight: .medium))
        subtitleLabel.numberOfLines = 2
        
    }
    private func setSnapkit(){
        view.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        image.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        headerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(150)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(headerLabel.snp.bottom).offset(5)
        }
        
        
    }
    func configure(sliderModel:Movies){
        self.image.setImage(with: sliderModel.posterPath?.setImageURL)
        self.headerLabel.text = sliderModel.title ?? ""
        self.subtitleLabel.text = sliderModel.overview ?? ""
        }
    

}
