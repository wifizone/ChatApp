//
//  AppDelegate.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 19/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	private var authenticationService: AuthenticationLogic?
	private var handle: AuthStateDidChangeListenerHandle?
	private var user: AuthStateDidChangeListenerHandle?
	private var assembly: Assembly?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		observeAuthorisedState()
		return true
	}

	private func observeAuthorisedState() {
        let authenticationService = AuthenticationService(auth: Auth.auth(),
                                                          delegate: self)
        self.authenticationService = authenticationService
		assembly = Assembly(authenticationService: authenticationService)
	}

	private func setupRootViewController(_ viewController: UIViewController) {
		window = UIWindow(frame: UIScreen.main.bounds)
		self.window!.rootViewController = viewController
		self.window!.makeKeyAndVisible()
	}
}

extension AppDelegate: AuthenticationDelegate {
	func stateDidChange(auth: Auth, user: User?) {
		if user == nil {
			guard let loginViewController = assembly?.login.makeLoginViewController(isRootViewController: true) else { return }
			self.setupRootViewController(loginViewController)
//        } else if !UserService.isNameAndPhotoUploaded() {
        } else if true {
			guard let user = user,
				let initProfileViewController = assembly?.login.makeProfileInitSetupViewController(user: user, isRootViewController: true) else { return
			}
			self.setupRootViewController(initProfileViewController)
		} else {
			guard let mainViewController = assembly?.main.makeMainViewController(isRootViewController: true) else { return }
			self.setupRootViewController(mainViewController)
		}
	}
}

