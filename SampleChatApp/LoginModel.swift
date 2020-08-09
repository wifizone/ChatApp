//
//  LoginModel.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 22/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import FirebaseAuth

struct LoginModel {
	struct User {
		let user: FirebaseAuth.User
	}
}
