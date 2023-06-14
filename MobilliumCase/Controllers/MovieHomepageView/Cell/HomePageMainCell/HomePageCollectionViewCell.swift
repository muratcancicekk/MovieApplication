//
//  HomePageCollectionViewCell.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.09.2022.
//

import UIKit
import SnapKit

class HomePageCollectionViewCell: UITableViewCell {
   private let headerTitle = UILabel()
   private let descriptionLabel = UILabel()
   private let icon = UIImageView()
   private let dateLabel = UILabel()
    private let imageViews = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubviews(imageViews, headerTitle, descriptionLabel, icon, dateLabel)
        applyStyle()
        setSnapkit()
    }

    private func applyStyle() {
        imageViews.image = UIImage(named: "dumydata")
        self.imageViews.layer.masksToBounds = true
        imageViews.cornerRadius = 8
        imageViews.contentMode = .scaleToFill
        headerTitle.styleLabel(title: "The Great Beauty (2013)", textAlignment: .left, color: .black, fontSize: UIFont.systemFont(ofSize: 15, weight: .bold))
        descriptionLabel.styleLabel(title: "Jep Gambardella has seduced his way through the lavish…", textAlignment: .left, color: .gray, fontSize: UIFont.systemFont(ofSize: 13, weight: .medium))
        dateLabel.styleLabel(title: "15.06.2021", textAlignment: .right, color: .gray, fontSize: UIFont.systemFont(ofSize: 12, weight: .medium))
        descriptionLabel.numberOfLines = 2
        icon.image = UIImage(named: "icon_right")



    }
    private func setSnapkit() {
        imageViews.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 104, height: 104))
        }
        headerTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-44)
            make.left.equalTo(imageViews.snp.right).offset(8)
            make.top.equalToSuperview().offset(25)

        }
        descriptionLabel.snp.makeConstraints { make in
            make.right.equalTo(icon.snp.left).offset(-11)
            make.top.equalTo(headerTitle.snp.bottom).offset(8)
            make.left.equalTo(imageViews.snp.right).offset(8)
        }
        icon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(64)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-44)
            make.bottom.equalToSuperview().offset(16)
        }


    }
    func configure(model:Movies){
        self.imageViews.setImage(with: model.posterPath?.setImageURL)
        self.headerTitle.text = model.title
        self.descriptionLabel.text = model.overview
        self.dateLabel.text = model.releaseDate
        
    }

}

