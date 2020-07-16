//
//  Assembly.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 20/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

final class Assembly {

	private let authenticationService: AuthenticationLogic

	init(authenticationService: AuthenticationLogic) {
		self.authenticationService = authenticationService
	}

	lazy var login = LoginAssembly(authenticationService: authenticationService)
    lazy var main = MainAssembly()
}
