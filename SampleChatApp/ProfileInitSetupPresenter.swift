//
//  ProfileInitSetupPresenter.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 28/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

protocol ProfileInitSetupPresentable {}

final class ProfileInitSetupPresenter {
	weak var viewController: ProfileInitSetupViewControllable?
}

extension ProfileInitSetupPresenter: ProfileInitSetupPresentable {}
