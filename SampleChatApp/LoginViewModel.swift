//
//  LoginViewModel.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 28/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

struct LoginViewModel {

	struct Registration {
		/// dummy
		let email: String
	}

	enum RegistrationError: Error {
		case error(message: String)
	}

	struct Login {
		/// dummy
		let email: String
	}

	enum LoginError: Error {
		case error(message: String)
	}
}
