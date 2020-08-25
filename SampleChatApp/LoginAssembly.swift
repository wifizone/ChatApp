//
//  LoginAssembly.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 20/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit
import FirebaseAuth

final class LoginAssembly {

	var router: LoginRouter?

	private let authenticationService: AuthenticationLogic

	init(authenticationService: AuthenticationLogic) {
		self.authenticationService = authenticationService
		router = LoginRouter(assembly: self)
	}

	func makeLoginViewController(isRootViewController: Bool) -> UIViewController {
		let presenter = LoginPresenter()
		let interactor = LoginInteractor(router: router,
										 presenter: presenter,
										 validationService: UserInputValidator(),
										 authenticationService: authenticationService)
		let viewController = LoginViewController(interactor: interactor)
		presenter.viewController = viewController
		setRootViewControllerIfNeeded(viewController, isRoot: isRootViewController)
		return viewController
	}

	func makeProfileInitSetupViewController(user: User, isRootViewController: Bool) -> UIViewController {
		let presenter = ProfileInitSetupPresenter()
		let interactor = ProfileInitSetupInteractor(router: router,
													presenter: presenter,
													storageService: ProfileStorageService(),
                                                    authenticationService: authenticationService,
                                                    userService: UserService(),
													user: user)
		let viewController = ProfileInitSetupViewController(interactor: interactor)
		presenter.viewController = viewController
		setRootViewControllerIfNeeded(viewController, isRoot: isRootViewController)
		return viewController
	}

	private func setRootViewControllerIfNeeded(_ viewController: UIViewController, isRoot: Bool) {
		if isRoot {
			router?.rootViewController = viewController
		}
	}
}
