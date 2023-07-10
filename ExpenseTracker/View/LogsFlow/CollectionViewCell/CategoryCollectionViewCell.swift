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
        
        // Hücre öğelerini burada özelleştirebilirsiniz
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Köşe yuvarlaklıkları ve diğer tasarım özelliklerini burada ayarlayın
        layer.cornerRadius = titleLabel.bounds.height
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.red.cgColor
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
