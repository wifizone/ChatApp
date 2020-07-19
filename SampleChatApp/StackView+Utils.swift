//
//  StackView+Utils.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 19/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

extension UIStackView {
	func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
