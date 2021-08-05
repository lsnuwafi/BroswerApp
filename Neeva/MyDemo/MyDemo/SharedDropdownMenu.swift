//
//  SharedDropdownMenu.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/11/21.
//

import Foundation
import UIKit

struct MenuItem {
    var name: String?
    var action: (() -> ())?
    
    static func item(named name: String, action: (() -> ())?) -> MenuItem {
        var menuItem = MenuItem()
        menuItem.name = "  " + name
        menuItem.action = action
        return menuItem
    }
}

class SharedDropdownMenu: UIView, UIGestureRecognizerDelegate {
    
    @objc static let defaultMenuItemHeight: CGFloat = 44
    @objc static let defaultMenuWidth: CGFloat = 250
    
    var menuItems: [MenuItem]?
    
    @objc var dismissGesture: UITapGestureRecognizer?
    
    var displayOrigin: CGPoint?
    
    init(menuItems: [MenuItem]) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.25
        self.clipsToBounds = true
        
        self.menuItems = menuItems
        setupMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setupMenu() {
        var itemViews = [UIView]()
        for (i, menuItem) in menuItems!.enumerated() {
            let button = UIButton()
            button.setTitle(menuItem.name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.lightGray, for: .highlighted)
            button.contentHorizontalAlignment = .left
            button.backgroundColor = .gray
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.gray.cgColor
            button.tag = i
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(self.tappedItem(sender:)), for: .touchUpInside)
                
            self.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: i == 0 ? self.topAnchor : itemViews[i - 1].bottomAnchor),
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                button.widthAnchor.constraint(equalTo: self.widthAnchor),
                button.heightAnchor.constraint(equalToConstant: SharedDropdownMenu.defaultMenuItemHeight)
            ])
    
                
            itemViews.append(button)
            
        }
    }
    
    @objc func show(in view: UIView, from point: CGPoint) {
        let bounds = view.bounds
        let height = SharedDropdownMenu.defaultMenuItemHeight * CGFloat(menuItems!.count)
        let width = SharedDropdownMenu.defaultMenuWidth
        displayOrigin = point
        
        var x = point.x - (width / 2)
        if x + width > bounds.width - 8 {
            x = bounds.width - width - 8
        }
        if x < 8 {
            x = 8
        }
        
        let finalFrame = CGRect(x: x, y: point.y, width: width, height: height)
        self.frame = CGRect(origin: point, size: .zero)
        view.addSubview(self)
        
        dismissGesture = UITapGestureRecognizer()
        dismissGesture?.delegate = self
        dismissGesture?.numberOfTapsRequired = 1
        view.window?.addGestureRecognizer(dismissGesture!)
        
        UIView.animate(withDuration: 0.25) {
            self.frame = finalFrame
        }
    }
    
    @objc func dismiss() {
        if let _ = dismissGesture {
            self.window?.removeGestureRecognizer(dismissGesture!)
        }
        
        guard let displayOrigin = displayOrigin else {
            self.removeFromSuperview()
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(origin: displayOrigin, size: .zero)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func tappedItem(sender: UIButton) {
        dismiss()
        guard let item = menuItems?[sender.tag] else { return }
        item.action?()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: nil)
        if !self.frame.contains(point) {
            self.dismiss()
            return false
        }
        return false
    }

}
