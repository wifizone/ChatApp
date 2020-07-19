//
//  UITableView+Utils.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func identifier() -> String {
        return String(describing: Self.self)
    }
}
