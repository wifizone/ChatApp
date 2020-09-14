//
//  LoginInteractor.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 20/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import FirebaseAuth

protocol LoginInteracting: AnyObject {
	func didTapRegister(email: String?, password: String?)
	func didTapLogin(email: String?, password: String?)
}

final class LoginInteractor {
	private let presenter: LoginPresentable
	private let validationService: UserInputValidatorProtocol
	private let authenticationService: AuthenticationLogic

	init(presenter: LoginPresentable,
		 validationService: UserInputValidatorProtocol,
		 authenticationService: AuthenticationLogic) {
		self.presenter = presenter
		self.validationService = validationService
		self.authenticationService = authenticationService
	}
}

extension LoginInteractor: LoginInteracting {

	func didTapRegister(email: String?, password: String?) {
		guard let email = email,
			let password = password else {
				return
		}
		do {
			try validationService.validate(email, type: .requiredField(field: "Name"))
			try validationService.validate(password, type: .requiredField(field: "Password"))
			try validationService.validate(email, type: .email)
			try validationService.validate(password, type: .password)
		} catch let error {
			if let error = error as? ValidationError {
				presenter.didFinishRegistration(isRegistered: .failure(.validationError(message: error.message)))
			}
			return
		}
		authenticationService.signUp(email: email, password: password) { [weak self] result in
			switch result {
			case let .success(model):
				self?.presenter.didFinishRegistration(isRegistered: .success(model))
			case .failure:
				self?.presenter.didFinishRegistration(isRegistered: .failure(.serverError))
			}
		}
	}

	func didTapLogin(email: String?, password: String?) {
		guard let email = email,
			let password = password else {
				return
		}
		do {
			try validationService.validate(email, type: .requiredField(field: "Name"))
			try validationService.validate(password, type: .requiredField(field: "Password"))
			try validationService.validate(email, type: .email)
		} catch let error {
			if let error = error as? ValidationError {
				presenter.didFinishLogin(isLoggedIn: .failure(.validationError(message: error.message)))
			}
			return
		}
		authenticationService.signIn(email: email, password: password) { [weak self] result in
			switch result {
			case let .success(model):
				self?.presenter.didFinishLogin(isLoggedIn: .success(model))
			case .failure:
				self?.presenter.didFinishLogin(isLoggedIn: .failure(.serverError))
			}
		}
	}
}
