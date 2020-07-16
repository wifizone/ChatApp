//
//  MainAssembly.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

final class MainAssembly {

    var router: MainRouter?

    private var tabBarViewController = UITabBarController()

    init() {
        router = MainRouter(assembly: self)
    }

    func makeMainViewController(isRootViewController: Bool) -> UIViewController {
        let presenter = ChatsViewControllerPresenter()
        let interactor = ChatsScreenInteractor(router: router,
                                               presenter: presenter)
        let viewController = ChatsViewController(interactor: interactor)
        let chatsNavigationController = UINavigationController(rootViewController: viewController)
        presenter.viewController = viewController
        chatsNavigationController.tabBarItem = UITabBarItem(title: "My messages", image: UIImage(named: "chats"), selectedImage: nil)
        tabBarViewController.viewControllers = [chatsNavigationController]
        setRootViewControllerIfNeeded(tabBarViewController, isRoot: isRootViewController)
        router?.chatsNavigationController = chatsNavigationController
        return tabBarViewController
    }

    private func setRootViewControllerIfNeeded(_ viewController: UITabBarController, isRoot: Bool) {
        if isRoot {
            router?.rootViewController = viewController
        }
    }
}
