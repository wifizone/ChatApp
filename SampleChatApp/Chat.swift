//
//  Chat.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 25.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

struct Chat {
	var users: [String]
	var dictionary: [String: Any] {
		return ["users": users]
	}
}

extension Chat {
	init?(dictionary: [String:Any]) {
		guard let chatUsers = dictionary["users"] as? [String] else {return nil}
		self.init(users: chatUsers)
	}
}
