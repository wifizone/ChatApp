//
//  LoginRouter.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 20/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol LoginRouting {
	func routeToProfileInitSetup(user: User)
	func finishFlow()
}

final class LoginRouter {

	var rootViewController: UIViewController?

	private weak var assembly: LoginAssembly?
	
	init(assembly: LoginAssembly) {
		self.assembly = assembly
	}
}

extension LoginRouter: LoginRouting {
	func routeToProfileInitSetup(user: User) {
		guard let rootViewController = rootViewController else {
			assertionFailure("rootViewController must be set")
			return
		}
		rootViewController.modalPresentationStyle = .overFullScreen
		if let viewController = assembly?.makeProfileInitSetupViewController(user: user, isRootViewController: false) {
			rootViewController.present(viewController, animated: true)
		}
	}

	func finishFlow() {
		
	}
}
