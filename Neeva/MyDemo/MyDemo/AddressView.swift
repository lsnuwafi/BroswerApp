//
//  AddressView.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/7/21.
//

import Foundation
import UIKit
class AddressView: UIView {

    weak var tabContainer: TabContainer?
    
    let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.setTitleColor(.lightGray, for: .disabled)
        backButton.tintColor = .lightGray
        backButton.isEnabled = false
        return backButton
    }()
    
    let forwardButton: UIButton = {
        let forwardButton = UIButton()
        forwardButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        forwardButton.setTitleColor(.black, for: .normal)
        forwardButton.setTitleColor(.lightGray, for: .disabled)
        forwardButton.tintColor = .lightGray
        forwardButton.isEnabled = false
        return forwardButton
    }()
    
    let urlTextField:SharedTextField = {
        let urlTextField = SharedTextField()
        urlTextField.placeholder = "Address"
        urlTextField.backgroundColor = .white
        urlTextField.layer.borderColor = UIColor.lightGray.cgColor
        urlTextField.layer.borderWidth = 0.5
        urlTextField.layer.cornerRadius = 4
        urlTextField.inset = 8
        
        urlTextField.autocorrectionType = .no
        urlTextField.autocapitalizationType = .none
        urlTextField.keyboardType = .webSearch

        urlTextField.clearButtonMode = .whileEditing

        return urlTextField
    }()
    
    let refreshButton: UIButton = {
        let refreshButton = UIButton()
        refreshButton.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        refreshButton.tintColor = .lightGray

        return refreshButton
    }()
    
    let menuButton: UIButton = {
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        return menuButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
        self.addSubview(backButton)
        self.addSubview(forwardButton)
        self.addSubview(refreshButton)
        self.addSubview(urlTextField)
        self.addSubview(menuButton)
        urlTextField.delegate = self
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            
            forwardButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 6),
            forwardButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: 32),
            
            refreshButton.leadingAnchor.constraint(equalTo: forwardButton.trailingAnchor, constant: 6),
            refreshButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 32),
            
            urlTextField.leadingAnchor.constraint(equalTo: refreshButton.trailingAnchor, constant: 8),
            urlTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            urlTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            urlTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            urlTextField.heightAnchor.constraint(equalToConstant: 40),
            
            
            menuButton.widthAnchor.constraint(equalToConstant: 25),
            menuButton.heightAnchor.constraint(equalToConstant: 25),
            menuButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            menuButton.leadingAnchor.constraint(equalTo: urlTextField.trailingAnchor)
        ])

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNaviagtionActions(forTabConatiner tabContainer: TabContainer) {
        backButton.addTarget(tabContainer, action: #selector(tabContainer.goBack(sender:)), for: .touchUpInside)
        forwardButton.addTarget(tabContainer, action: #selector(tabContainer.goForward(sender:)), for: .touchUpInside)
        refreshButton.addTarget(tabContainer, action: #selector(tabContainer.refresh(sender:)), for: .touchUpInside)
    }
    
    

}

extension AddressView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tabContainer!.loadRequest(string: textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func setAddressText(_ text: String?) {
        
        if !urlTextField.isFirstResponder {
            urlTextField.text = text
        }
    }
}
