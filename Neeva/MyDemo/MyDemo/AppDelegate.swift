//
//  AppDelegate.swift
//  MyDemo
//
//  Created by Shinan Liu on 3/22/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //let navigationController = UINavigationController(rootViewController: ViewController())
       
       
        let viewController = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .blue
        window?.makeKeyAndVisible()
        window?.rootViewController = viewController
        print("teste")
        return true
    }


}

