//
//  AuthenticationService.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 22/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation
import Firebase

enum AuthenticationError: Error {
	case signUp
	case signIn
}

protocol AuthenticationLogic: AnyObject {
	func signUp(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void)
	func signIn(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void)
}

protocol AuthenticationDelegate: AnyObject {
	func stateDidChange(auth: Auth, user: User?)
}

final class AuthenticationService: AuthenticationLogic {

	var authStateHandler: ((Bool) -> Void)?

	private let auth: Auth
	private var handler: AuthStateDidChangeListenerBlock?
	private weak var delegate: AuthenticationDelegate?
	private var isAuthenticated: Bool = false

	init(auth: Auth, delegate: AuthenticationDelegate) {
		self.auth = auth
		self.delegate = delegate
		auth.addStateDidChangeListener(authStateHandler)
	}

	func signUp(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void) {
		auth.createUser(withEmail: email, password: password) { (user, error) in
			guard let email = user?.user.email, error == nil else { return completion(.failure(.signUp)) }
			completion(.success(LoginModel.User(email: email)))
		}
	}

	func signIn(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void) {
		auth.signIn(withEmail: email, password: password) { [weak self] (user, error) in
			guard let email = user?.user.email, error == nil else { return completion(.failure(.signIn)) }
			self?.isAuthenticated = true
			completion(.success(LoginModel.User(email: email)))
		}
	}

	private func authStateHandler(auth: Auth, user: User?) {
		delegate?.stateDidChange(auth: auth, user: user)
	}
}
