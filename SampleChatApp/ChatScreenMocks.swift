//
//  ChatScreenMocks.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

/// Mocks for chat screen
struct ChatScreenMocks {
    static func get() -> ChatsScreenViewModel.Chats {
        let avatar1URL = URL(string: "https://miro.medium.com/fit/c/256/256/2*pi9JhETX0ZUr59ZQv3VHkw.jpeg")
        let chat1 = ChatsScreenViewModel.ChatWithUser(name: "Elizabeth, 21",
                                                      lastMessage: "Hi, were u from?",
                                                      avatarURL: avatar1URL,
                                                      time: "12:45",
                                                      numberOfUnreadMessages: 3)
        let avatar2URL = URL(string: "https://www.payal.co.uk/wp-content/uploads/2016/02/Faces-400x400px-1_1_07-scalia-testimonial.jpg")
        let chat2 = ChatsScreenViewModel.ChatWithUser(name: "Patrick, 31",
                                                      lastMessage: "Did you remove the texture from the project?",
                                                      avatarURL: avatar2URL,
                                                      time: "11:34",
                                                      numberOfUnreadMessages: 0)
        let avatar3URL = URL(string: "https://www.ewdn.com/wp-content/uploads/sites/6/2019/03/i0lljrcib7gnvke7wa7w.jpg")
        let chat3 = ChatsScreenViewModel.ChatWithUser(name: "Steve, 38",
                                                      lastMessage: "probably scanned for policy problems.",
                                                      avatarURL: avatar3URL,
                                                      time: "11:25",
                                                      numberOfUnreadMessages: 0)
        let avatar4URL = URL(string: "https://villasplitluxury.com/wp-content/uploads/2015/02/Faces-400x400px-1_1_18-scalia-testimonial.jpg")
        let chat4 = ChatsScreenViewModel.ChatWithUser(name: "Bergman, 22",
                                                      lastMessage: "For who who cant wink, I've added a head",
                                                      avatarURL: avatar4URL,
                                                      time: "10:45",
                                                      numberOfUnreadMessages: 3)
        let avatar5URL = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSzbyMqxASK2X8mkIJbiKowyhMkhVJEH_ANXw&usqp=CAU")
        let chat5 = ChatsScreenViewModel.ChatWithUser(name: "Danay, 24",
                                                      lastMessage: "Create a tutorial video, plz 🙏🙏🙏🙏",
                                                      avatarURL: avatar5URL,
                                                      time: "09:06",
                                                      numberOfUnreadMessages: 1)
        return ChatsScreenViewModel.Chats(chats: [chat1, chat2, chat3, chat4, chat5])
    }
}
