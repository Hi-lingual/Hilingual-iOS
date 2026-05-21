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
        setupUI()
        updateState(isListening: false, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        clipsToBounds = false
        accessibilityLabel = "음성 재생"
    }

    // MARK: - State

    func updateState(isListening: Bool, animated: Bool = true) {
        let changes = {
            self.configuration = self.makeConfiguration(isListening: isListening)
            self.backgroundColor = self.backgroundColor(isListening: isListening)
            self.tintColor = .hilingualBlue
            self.layer.cornerRadius = 12
            self.layer.borderWidth = self.borderWidth(isListening: isListening)
            self.layer.borderColor = UIColor.hilingualBlue.cgColor
        }

        if animated {
            UIView.transition(
                with: self,
                duration: 0.18,
                options: [.transitionCrossDissolve, .allowUserInteraction],
                animations: changes
            )
        } else {
            changes()
        }
    }
}

// MARK: - Private Methods

private extension ListeningButton {
    func makeConfiguration(isListening: Bool) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = iconImage(isListening: isListening)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
        configuration.baseForegroundColor = .hilingualBlue
        return configuration
    }

    func iconImage(isListening: Bool) -> UIImage? {
        let imageName = isListening ? "ic_pause_20_ios" : "ic_play_20_ios"
        return UIImage(named: imageName, in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }

    func backgroundColor(isListening: Bool) -> UIColor {
        return isListening ? .white : UIColor.hilingualBlue.withAlphaComponent(0.16)
    }

    func borderWidth(isListening: Bool) -> CGFloat {
        return isListening ? 1 : 0
    }
}
