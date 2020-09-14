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
    private var userService: UserServiceProtocol?
	private var handle: AuthStateDidChangeListenerHandle?
	private var user: AuthStateDidChangeListenerHandle?
	private var assembly: Assembly?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		setupServices()
		return true
	}

    private func setupServices() {
        let authenticationService = AuthenticationService(auth: Auth.auth(),
                                                      delegate: self)
        self.authenticationService = authenticationService
        userService = UserService()
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
		if let user = user {
            checkProfileIsFull(user: user) { [unowned self] isComplete in
                if isComplete {
                    self.startMain()
                } else {
                    self.startInitProfile(user: user)
                }
            }
        } else {
            startLogin()
        }
	}

    private func checkProfileIsFull(user: User, checkCompletion: @escaping (Bool) -> Void) {
        userService?.isUserProfileFull(user: user, completion: { result in
            switch result {
            case let .success(boolResult):
                checkCompletion(boolResult)
            case .failure:
                checkCompletion(false)
            }
        })
    }

    private func startMain() {
        guard let mainViewController = assembly?.main.makeMainViewController(isRootViewController: true) else { return }
        self.setupRootViewController(mainViewController)
    }

    private func startInitProfile(user: User) {
        guard let initProfileViewController = assembly?.main.makeProfileInitSetupViewController(user: user,
                                                                                                isRootViewController: true,
                                                                                                completion: startMain) else { return }
        self.setupRootViewController(initProfileViewController)
    }

    private func startLogin() {
        guard let loginViewController = assembly?.login.makeLoginViewController(isRootViewController: true) else { return }
        self.setupRootViewController(loginViewController)
    }
}

