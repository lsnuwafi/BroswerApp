//
//  BookmarkCell.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/11/21.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    var titleTextField: SharedTextField!
    var urlTextField: SharedTextField!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        titleTextField = SharedTextField()
        titleTextField.inset = 8
        titleTextField.placeholder = "Bookmark Name"
        titleTextField.clearButtonMode = .always
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        urlTextField = SharedTextField()
        urlTextField.inset = 8
        urlTextField.placeholder = "Bookmark URL"
        urlTextField.clearButtonMode = .always
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.contentView.addSubview(urlTextField)
        self.contentView.addSubview(titleTextField)

        
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            urlTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            urlTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            urlTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            urlTextField.heightAnchor.constraint(equalToConstant: 44),
            contentView.bottomAnchor.constraint(equalTo: urlTextField.bottomAnchor)
        ])
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
