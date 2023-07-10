//
//  CategoryCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Furkan Erzurumlu on 9.07.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.gray
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        let widthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: frame.width)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = titleLabel.bounds.height
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        
        titleLabel.preferredMaxLayoutWidth = contentView.bounds.width - 20
        titleLabel.textAlignment = .center
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
                
                let targetSize = CGSize(width: contentView.bounds.width, height: layoutAttributes.frame.height)
                let size = titleLabel.sizeThatFits(targetSize)
                attributes.frame.size.width = ceil(size.width) + 20
                
                return attributes
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
