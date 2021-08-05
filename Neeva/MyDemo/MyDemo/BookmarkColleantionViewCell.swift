//
//  BookmarkCell.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/11/21.
//

import Foundation
import UIKit

protocol BookmarkCollectionViewCellDelegate: class {
    func deleteBookmark()
}


class BookmarkCollectionViewCell: UICollectionViewCell {
    var textLabel: UILabel!
    var xButton: UIButton!
    var delegate: BookmarkCollectionViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xButton = UIButton()
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        
        xButton.addTarget(self, action: #selector(deleteBookmark), for: .touchUpInside)
        textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.minimumScaleFactor = 0.8
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = UIColor.gray.cgColor
        self.contentView.addSubview(textLabel)
        self.contentView.addSubview(xButton)
       // self.textLabel = textLabel
 //       imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            textLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            xButton.widthAnchor.constraint(equalToConstant: 15),
            xButton.heightAnchor.constraint(equalToConstant: 15),
            xButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            xButton.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
      
    }
    
    @objc func deleteBookmark(sender: UIButton) {
        _ = delegate?.deleteBookmark()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
