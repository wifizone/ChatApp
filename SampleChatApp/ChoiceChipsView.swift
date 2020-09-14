//
//  ChoiceChipsView.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 23.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

protocol ChoiceChipsViewDelegate: AnyObject {
    func didMakeChip(at index: Int, selected: Bool)
}

enum ChoiceSelectionType {
    case single
    case multiple
}

final class ChoiceChipsView: UIView {

    private let chipsTitles: [String]
    private let choiceSelectionType: ChoiceSelectionType
    private var previouslySelectedChip: ChipView?
    private weak var delegate: ChoiceChipsViewDelegate?

    private let stackView: UIStackView = {
        let stack = UIStackView().disableMasks()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 17
        return stack
    }()

    init(delegate: ChoiceChipsViewDelegate, chipsTitles: [String], selection: ChoiceSelectionType = .multiple) {
        self.chipsTitles = chipsTitles
        self.choiceSelectionType = selection
        super.init(frame: .zero)
        self.delegate = delegate
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        for (index, text) in chipsTitles.enumerated() {
            let chip = ChipView(text: text, selected: { [unowned self] chip, selected in
                if let previouslySelectedChip = self.previouslySelectedChip,
                    selected,
                    self.choiceSelectionType == .single {
                    previouslySelectedChip.isSelected.toggle()
                }
                self.delegate?.didMakeChip(at: index, selected: selected)
                self.previouslySelectedChip = chip
            })
            chip.heightAnchor.constraint(equalToConstant: 30).isActive = true
            chip.widthAnchor.constraint(equalToConstant: 100).isActive = true
            stackView.addArrangedSubview(chip)
        }
        addSubview(stackView)
        stackView.pin(to: .all, of: self)
    }
}
