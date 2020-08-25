//
//  UserInfo.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 09.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

struct UserInfo {
    let id: String
    let displayName: String?
    var photoURL: URL?

    init?(userData: [String: Any]?) {
        guard let userData = userData,
            let id = userData["id"] as? String else { return nil }
        self.id = id
        self.displayName = userData["displayName"] as? String
        if let photoURLString = userData["avatarURL"] as? String {
            self.photoURL = URL(string: photoURLString)
        }
    }
}
