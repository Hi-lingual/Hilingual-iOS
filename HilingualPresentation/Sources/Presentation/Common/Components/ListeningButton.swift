//
//  ListeningButton.swift
//  HilingualPresentation
//
//  Created by 성현주 on 5/21/26.
//

import UIKit

final class ListeningButton: UIButton {

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateState(isListening: false, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - State

    func updateState(isListening: Bool, animated: Bool = true) {
        let changes = {
            self.configuration = self.makeConfiguration(isListening: isListening)
            self.backgroundColor = isListening ? .white : UIColor.hilingualBlue.withAlphaComponent(0.16)
            self.tintColor = .hilingualBlue
            self.layer.cornerRadius = 12
            self.layer.borderWidth = isListening ? 1 : 0
            self.layer.borderColor = UIColor.hilingualBlue.cgColor
        }

        if animated {
            UIView.transition(with: self, duration: 0.18, options: [.transitionCrossDissolve, .allowUserInteraction], animations: changes)
        } else {
            changes()
        }
    }
}

// MARK: - Private Methods

private extension ListeningButton {
    func makeConfiguration(isListening: Bool) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(resource: isListening ? .icPause20Ios : .icPlay20Ios).withRenderingMode(.alwaysOriginal)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
        configuration.baseForegroundColor = .hilingualBlue
        return configuration
    }
}
