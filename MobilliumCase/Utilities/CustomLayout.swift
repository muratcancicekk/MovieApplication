//
//  CustomLayout.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 14.06.2023.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Configure the layout for the horizontal cell
        let horizontalCellSize = CGSize(width: collectionView.bounds.width, height: 200)
        let horizontalCellIndexPath = IndexPath(item: 0, section: 0)
        let horizontalCellAttributes = UICollectionViewLayoutAttributes(forCellWith: horizontalCellIndexPath)
        horizontalCellAttributes.frame = CGRect(origin: .zero, size: horizontalCellSize)
        self.layoutAttributes.append(horizontalCellAttributes)
        
        // Configure the layout for the vertical cell
        let verticalCellSize = CGSize(width: 200, height: collectionView.bounds.height)
        let verticalCellIndexPath = IndexPath(item: 1, section: 0)
        let verticalCellAttributes = UICollectionViewLayoutAttributes(forCellWith: verticalCellIndexPath)
        verticalCellAttributes.frame = CGRect(origin: CGPoint(x: horizontalCellSize.width, y: 0), size: verticalCellSize)
        self.layoutAttributes.append(verticalCellAttributes)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let horizontalCellSize = CGSize(width: collectionView.bounds.width, height: 200)
        let verticalCellSize = CGSize(width: 200, height: collectionView.bounds.height)
        
        let contentWidth = horizontalCellSize.width + verticalCellSize.width
        let contentHeight = max(horizontalCellSize.height, verticalCellSize.height)
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
}
