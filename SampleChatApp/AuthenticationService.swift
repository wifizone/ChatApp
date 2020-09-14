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
    case updating
    case updatingProfileIsFull
}

protocol AuthenticationLogic: AnyObject {
	func signUp(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void)
	func signIn(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void)
    func logout() throws
	func updateUser(name: String, photoURL: URL, completion: @escaping (AuthenticationError?) -> Void)
}

protocol AuthenticationDelegate: AnyObject {
	func stateDidChange(auth: Auth, user: User?)
}

final class AuthenticationService: AuthenticationLogic {

	var authStateHandler: ((Bool) -> Void)?

	private let auth: Auth
	private var handler: AuthStateDidChangeListenerBlock?
	private weak var delegate: AuthenticationDelegate?

    init(auth: Auth, delegate: AuthenticationDelegate) {
		self.auth = auth
		self.delegate = delegate
		auth.addStateDidChangeListener(authStateHandler)
	}

	func signUp(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void) {
		auth.createUser(withEmail: email, password: password) { (user, error) in
			guard let user = user?.user, error == nil else { return completion(.failure(.signUp)) }
            completion(.success(LoginModel.User(user: user)))
		}
	}

	func signIn(email: String, password: String, completion: @escaping (Result<(LoginModel.User), AuthenticationError>) -> Void) {
		auth.signIn(withEmail: email, password: password) { (user, error) in
			guard let user = user?.user, error == nil else { return completion(.failure(.signIn)) }
			completion(.success(LoginModel.User(user: user)))
		}
	}

	func updateUser(name: String, photoURL: URL, completion: @escaping (AuthenticationError?) -> Void) {
		let changeRequest = auth.currentUser?.createProfileChangeRequest()
		changeRequest?.displayName = name
		changeRequest?.photoURL = photoURL
		changeRequest?.commitChanges(completion: { error in
            switch error {
            case .some:
                completion(.updating)
            case .none:
                completion(nil)
            }
		})
	}

    func logout() throws {
        try auth.signOut()
    }

	private func authStateHandler(auth: Auth, user: User?) {
		delegate?.stateDidChange(auth: auth, user: user)
	}
}
