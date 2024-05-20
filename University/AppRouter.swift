//
//  AppRouter.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//


import UIKit

final class AppRouter {
    var window: UIWindow?
    
    func start(_ scene: UIWindowScene) {
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        let controller = SplashViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    func newViewControl(for viewController: UIViewController) {
        guard let window else { return }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
