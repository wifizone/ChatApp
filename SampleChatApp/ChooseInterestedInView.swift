//
//  ChooseInterestedInView.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 23.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

final class ChooseInterestedInView: UIView {

    var selectedInterests = Set<String>()
    private let interests: [String]

    private let stackView: UIStackView = {
        let stack = UIStackView().disableMasks()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 19
        return stack
    }()

    private lazy var choiceView = ChoiceChipsView(delegate: self, chipsTitles: interests).disableMasks()

    private var interestedInLabel: UILabel = {
        let label = UILabel().disableMasks()
        label.text = "Interested in"
        return label
    }()

    init(interests: [String]) {
        self.interests = interests
        super.init(frame: .zero)
        addSubview(stackView)
        stackView.pin(to: .all, of: self)
        [interestedInLabel, choiceView].forEach({ stackView.addArrangedSubview($0) })
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ChooseInterestedInView: ChoiceChipsViewDelegate {
    func didMakeChip(at index: Int, selected: Bool) {
        if selected {
            selectedInterests.insert(interests[index])
        } else {
            selectedInterests.remove(interests[index])
        }
    }
}
