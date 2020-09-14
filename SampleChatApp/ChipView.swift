//
//  ChipView.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 23.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

final class ChipView: UIButton {

    private let chipTitle: String
    private let selectedClosure: (_ chip: ChipView, _ selected: Bool) -> Void
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = UIColor.red.cgColor
            } else {
                layer.borderColor = UIColor.gray.cgColor
            }
            selectedClosure(self, isSelected)
        }
    }

    init(text: String, selected: @escaping (ChipView, Bool) -> Void) {
        self.chipTitle = text
        self.selectedClosure = selected
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        setTitle(chipTitle, for: .normal)
        setTitleColor(.black, for: .normal)
        setTitle(chipTitle, for: .selected)
        setTitleColor(.black, for: .selected)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton() {
        isSelected.toggle()
    }
}
