//
//  TabView.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/7/21.
//

import Foundation
import UIKit

protocol TabViewDelegate: class {
    func didTap(tab: TabView)
    func close(tab: TabView) -> Bool
}

class TabView: UIView{
    
    @objc var shapeLayer: CAShapeLayer?
    
    @objc var tabTitle: String? {
        didSet {
            tabTitleLabel.text = tabTitle
        }
    }
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(close(sender: )), for: .touchUpInside)
        return closeButton
    }()
    
    let tabImageView: UIImageView = {
        let tabImageView = UIImageView()
        tabImageView.image = UIImage(systemName: "globe")
        tabImageView.contentMode = .scaleAspectFit
        return tabImageView
    }()
    
    var tabTitleLabel: UILabel = {
        let tabTitleLabel = UILabel()
        tabTitleLabel.text = "New Tab"
        tabTitleLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize - 0.5)
        return tabTitleLabel
    }()
    
    weak var delegate: TabViewDelegate?
    var webContainer: WebContainer?
    
    @objc init(parentView: UIView) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.addSubview(closeButton)
        self.addSubview(tabImageView)
        self.addSubview(tabTitleLabel)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        tabImageView.translatesAutoresizingMaskIntoConstraints = false
        tabTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -25),
            closeButton.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -25),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            
            tabImageView.widthAnchor.constraint(equalToConstant: 15),
            tabImageView.heightAnchor.constraint(equalToConstant: 15),
            tabImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            tabImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            tabTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            tabTitleLabel.leadingAnchor.constraint(equalTo: self.tabImageView.trailingAnchor, constant: 4),
            tabTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            tabTitleLabel.trailingAnchor.constraint(equalTo: self.closeButton.leadingAnchor, constant: -4),
        ])
        
        
        let gesture = UITapGestureRecognizer()
        gesture.delegate = self
        gesture.addTarget(self, action: #selector(tappedTab))
        gesture.cancelsTouchesInView = false
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
        debugPrint("aaa tabView parent", parentView)
        webContainer = WebContainer(parent: parentView)
      //  webContainer!.translatesAutoresizingMaskIntoConstraints = false
        webContainer?.tabView = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
 //       self.blendCorner(corner: .All, shapeLayer: &shapeLayer, length: 10)
    }
    
    @objc func tappedTab(sender: UITapGestureRecognizer) {
        delegate?.didTap(tab: self)
    }
    
    @objc func close(sender: UIButton) {
        _ = delegate?.close(tab: self)
    }
}

extension TabView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
                    return false
                }
        
                return true
    }
}

