//
//  ProfileInitSetupInteractor.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 28/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

protocol ProfileInitSetupInteracting: AnyObject {}

final class ProfileInitSetupInteractor {
	private let presenter: ProfileInitSetupPresentable
	private let router: LoginRouting?

	init(router: LoginRouting?,
		 presenter: ProfileInitSetupPresentable) {
		self.router = router
		self.presenter = presenter
	}
}

extension ProfileInitSetupInteractor: ProfileInitSetupInteracting {}
