//
//  CollectionCell.swift
//  CTXTutorialEngineExample
//
//  Created by Andrey Medvedev on 23.09.2020.
//  Copyright © 2020 andymedvedev. All rights reserved.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    
    static let reuseId = "cell"
    static let cellSize = CGSize(width: 80, height: 80)
    
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        textLabel.font = .systemFont(ofSize: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.sizeToFit()
        textLabel.center = contentView.center
    }
    
    func configure(by index: Int) {
        let accessibilityViewsRange = (4...6)
        
        if accessibilityViewsRange.contains(index) {
            accessibilityIdentifier = "orangeCell"
            backgroundColor = .orange
            textLabel.textColor = .white
        } else {
            accessibilityIdentifier = nil
            backgroundColor = .lightGray
            textLabel.textColor = .black
        }
        
        textLabel.text = "\(index)"
        setNeedsLayout()
    }
}
