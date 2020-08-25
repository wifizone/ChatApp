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
                                               presenter: presenter,
                                               chatService: ChatService(),
                                               userService: UserService())
        let viewController = ChatsViewController(interactor: interactor)
        let chatsNavigationController = UINavigationController(rootViewController: viewController)
        presenter.viewController = viewController
        chatsNavigationController.tabBarItem = UITabBarItem(title: "My messages", image: UIImage(named: "chats"), selectedImage: nil)
        tabBarViewController.viewControllers = [chatsNavigationController]
        setRootViewControllerIfNeeded(tabBarViewController, isRoot: isRootViewController)
        router?.chatsNavigationController = chatsNavigationController
        return tabBarViewController
    }

	func makeChatViewController() -> UIViewController {
		let vc = ChatViewController()
		vc.user2Name = "MMM"
		vc.user2ImgUrl = "https://firebasestorage.googleapis.com/v0/b/chatsample-93b85.appspot.com/o/users%2FB3MjPI3BHwezILaeRm96cKkTAm12%2Favatar.jpg?alt=media&token=b2913ec3-844c-4f6e-80e0-2b063c6889f6"
		vc.user2UID = "B3MjPI3BHwezILaeRm96cKkTAm12"
		return vc
	}

    private func setRootViewControllerIfNeeded(_ viewController: UITabBarController, isRoot: Bool) {
        if isRoot {
            router?.rootViewController = viewController
        }
    }
}
