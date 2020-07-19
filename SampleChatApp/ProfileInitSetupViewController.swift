//
//  ProfileInitSetupViewController.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 28/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

protocol ProfileInitSetupViewControllable: AnyObject {}

final class ProfileInitSetupViewController: UIViewController {

	private let interactor: ProfileInitSetupInteracting
	
	init(interactor: ProfileInitSetupInteracting) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ProfileInitSetupViewController: ProfileInitSetupViewControllable {}
