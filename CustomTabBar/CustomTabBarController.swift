//
//  CustomTabBarController.swift
//  Stoked
//
//  Created by Noah Hurley on 6/30/24.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    private var previousIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
           selectedIndex == previousIndex
        {
            if let navController = viewController as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }
        previousIndex = tabBarController.selectedIndex
    }
}
