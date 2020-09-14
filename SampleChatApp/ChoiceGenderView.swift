//
//  ChoiceGenderView.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 23.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

final class ChoiceGenderView: UIView {

    var selectedGender = Set<String>()
    private let genders: [String]

    private let stackView: UIStackView = {
        let stack = UIStackView().disableMasks()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 17
        return stack
    }()

    private lazy var choiceView = ChoiceChipsView(delegate: self, chipsTitles: genders, selection: .single).disableMasks()

    private var genderLabel: UILabel = {
        let label = UILabel().disableMasks()
        label.text = "Your gender"
        return label
    }()

    init(genders: [String]) {
        self.genders = genders
        super.init(frame: .zero)
        addSubview(stackView)
        stackView.pin(to: .all, of: self)
        [genderLabel, choiceView].forEach({ stackView.addArrangedSubview($0) })
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ChoiceGenderView: ChoiceChipsViewDelegate {
    func didMakeChip(at index: Int, selected: Bool) {
        if selected {
            selectedGender.insert(genders[index])
        } else {
            selectedGender.remove(genders[index])
        }
    }
}
