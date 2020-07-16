//
//  LoginRouter.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 20/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

protocol LoginRouting {
	func routeToProfileInitSetup()
}

final class LoginRouter {

	var rootViewController: UIViewController?

	private weak var assembly: LoginAssembly?
	
	init(assembly: LoginAssembly) {
		self.assembly = assembly
	}
}

extension LoginRouter: LoginRouting {
	func routeToProfileInitSetup() {
		guard let rootViewController = rootViewController else {
			assertionFailure("rootViewController must be set")
			return
		}
		rootViewController.modalPresentationStyle = .overFullScreen
		if let viewController = assembly?.makeProfileInitSetupViewController() {
			rootViewController.present(viewController, animated: true)
		}
	}
}
