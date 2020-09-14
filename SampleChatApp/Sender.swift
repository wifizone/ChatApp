//
//  Sender.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 25.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import MessageKit

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}
