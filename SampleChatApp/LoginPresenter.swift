//
//  LoginPresenter.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 20/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

enum RegistrationError: Error {
	case validationError(message: String)
	case serverError
}

enum LoginError: Error {
	case validationError(message: String)
	case serverError
}

protocol LoginPresentable {
	func didFinishRegistration(isRegistered: Result<LoginModel.User, RegistrationError>)
	func didFinishLogin(isLoggedIn: Result<LoginModel.User, LoginError>)
}

final class LoginPresenter {

	weak var viewController: LoginViewControllable?
}

extension LoginPresenter: LoginPresentable {

	func didFinishRegistration(isRegistered: Result<LoginModel.User, RegistrationError>) {
		switch isRegistered {
		case let .success(model):
			viewController?.showUpdate(update: .success(LoginViewModel.Registration(email: model.user.email ?? "")))
		case let .failure(error):
			switch error {
			case .serverError:
				viewController?.showUpdate(update: .failure(LoginViewModel.RegistrationError.error(message: "Try again")))
			case let .validationError(message: message):
				viewController?.showUpdate(update: .failure(LoginViewModel.RegistrationError.error(message: message)))
			}
		}
	}

	func didFinishLogin(isLoggedIn: Result<LoginModel.User, LoginError>) {
		switch isLoggedIn {
		case let .success(model):
			viewController?.showUpdate(update: .success(LoginViewModel.Login(user: model.user)))
		case let .failure(error):
			switch error {
			case .serverError:
				viewController?.showUpdate(update: .failure(LoginViewModel.LoginError.error(message: "Try again")))
			case let .validationError(message: message):
				viewController?.showUpdate(update: .failure(LoginViewModel.LoginError.error(message: message)))
			}
		}
	}
}
