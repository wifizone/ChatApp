//
//  UIView+Utils.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 19/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

// MARK: - Constraints

extension UIView {
    @discardableResult
    func disableMasks() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    func pin(to edges: UIRectEdge, of view: UIView, with insets: UIEdgeInsets = .zero, respectingSafeArea: Bool = false) {
        NSLayoutConstraint.activate(pinnedConstraints(to: edges, of: view, with: insets, respectingSafeArea: respectingSafeArea))
    }

    func pinnedConstraints(to edges: UIRectEdge,
                           of view: UIView,
                           with insets: UIEdgeInsets = .zero,
                           respectingSafeArea: Bool) -> [NSLayoutConstraint] {
        var newInsets = insets
        if respectingSafeArea, let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets {
            newInsets = UIEdgeInsets(top: insets.top + safeAreaInsets.top,
                                     left: insets.left + safeAreaInsets.left,
                                     bottom: insets.bottom + safeAreaInsets.bottom,
                                     right: insets.right + safeAreaInsets.right)
        }
        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: newInsets.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -newInsets.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: newInsets.left))
        }
        if edges.contains(.right) {
            constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: -newInsets.right))
        }

        return constraints
    }
}

// MARK: - Views

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
