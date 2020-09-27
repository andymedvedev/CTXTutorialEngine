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
        textLabel.font = .systemFont(ofSize: 12)
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 0
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
            accessibilityIdentifier = "cell"
            textLabel.text = "will be\nhinted..."
            backgroundColor = UIColor(named: "burntSienna")
            textLabel.textColor = UIColor(named: "regalBlue")
        } else {
            accessibilityIdentifier = nil
            textLabel.text = "lorem ipsum"
            backgroundColor = UIColor(named: "royalBlue")
            textLabel.textColor = UIColor(named: "paleYellow")
        }
        setNeedsLayout()
    }
}
