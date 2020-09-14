//
//  MainAssembly.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit
import FirebaseAuth

final class MainAssembly {

    var router: MainRouter?

    private var tabBarViewController = UITabBarController()

    private var authenticationService: AuthenticationLogic

    init(authenticationService: AuthenticationLogic) {
        self.authenticationService = authenticationService
        router = MainRouter(assembly: self)
    }

    func makeProfileInitSetupViewController(user: User, isRootViewController: Bool, completion: @escaping () -> Void) -> UIViewController {
        let presenter = ProfileInitSetupPresenter()
        let interactor = ProfileInitSetupInteractor(router: router,
                                                    presenter: presenter,
                                                    storageService: ProfileStorageService(),
                                                    authenticationService: authenticationService,
                                                    userService: UserService(),
                                                    user: user,
                                                    completion: completion)
        let viewController = ProfileInitSetupViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }

    func makeMainViewController(isRootViewController: Bool) -> UIViewController {
        let chatsNavigationController = UINavigationController(rootViewController: makeChatViewController())
        chatsNavigationController.tabBarItem = UITabBarItem(title: "My messages", image: UIImage(named: "chats"), selectedImage: nil)
        let profileViewController = makeProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: nil)
        tabBarViewController.viewControllers = [chatsNavigationController, profileViewController]
        setRootViewControllerIfNeeded(tabBarViewController, isRoot: isRootViewController)
        router?.chatsNavigationController = chatsNavigationController
        return tabBarViewController
    }

    func makeChatViewController() -> UIViewController {
        let presenter = ChatsViewControllerPresenter()
        let interactor = ChatsScreenInteractor(router: router,
                                               presenter: presenter,
                                               chatService: ChatService(),
                                               userService: UserService())
        let viewController = ChatsViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }

    func makeProfileViewController() -> UIViewController {
        let interactor = ProfileInteractor(router: router, authenticationService: authenticationService)
        let viewController = ProfileViewController(interactor: interactor)
        return viewController
    }

    private func setRootViewControllerIfNeeded(_ viewController: UITabBarController, isRoot: Bool) {
        if isRoot {
            router?.rootViewController = viewController
        }
    }
}
