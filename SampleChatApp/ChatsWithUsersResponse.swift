//
//  ChatsWithUsersResponse.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 02.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

struct ChatsWithUsersResponse {
	struct Chats {
        var chats = [ChatWithUser]()
    }

    /// A model represents a user in your chats screen
    struct ChatWithUser {
		let userID: UUID
        let name: String
        let avatarURL: URL?
    }
}
