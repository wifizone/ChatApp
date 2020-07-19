//
//  ChatsScreenViewModel.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

struct ChatsScreenViewModel {

    struct Chats {
        var chats = [ChatWithUser]()
    }

    /// A model represents a user in your chats screen
    struct ChatWithUser {
        let name: String
        let lastMessage: String
        let avatarURL: URL?
        let time: String
        let numberOfUnreadMessages: UInt
    }
}
