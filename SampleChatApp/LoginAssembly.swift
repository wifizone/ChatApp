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

	private let authenticationService: AuthenticationLogic

	init(authenticationService: AuthenticationLogic) {
		self.authenticationService = authenticationService
	}

	func makeLoginViewController(isRootViewController: Bool) -> UIViewController {
		let presenter = LoginPresenter()
		let interactor = LoginInteractor(presenter: presenter,
										 validationService: UserInputValidator(),
										 authenticationService: authenticationService)
		let viewController = LoginViewController(interactor: interactor)
		presenter.viewController = viewController
		return viewController
	}
}
