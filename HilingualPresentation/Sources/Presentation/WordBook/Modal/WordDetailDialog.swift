//
//  WordDetailDialog.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/14/25.
//

import UIKit
import SnapKit

final class WordDetailDialog: UIView {

    // MARK: - Callback

    var onBookmarkToggled: ((Int, Bool) -> Void)?

    // MARK: - UI Components

    private let dialogContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private let wordCard = WordCard()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setStyle() {
        backgroundColor = .dim
        self.isHidden = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.addGestureRecognizer(tap)
    }

    private func setUI() {
        addSubview(dialogContainerView)
        dialogContainerView.addSubview(wordCard)
    }

    private func setLayout() {
        dialogContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        wordCard.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Public Method

    func configure(data: PhraseData) {
        wordCard.configure(type: .withDate, data: data)

        wordCard.onBookmarkToggled = { [weak self] isMarked in
            self?.onBookmarkToggled?(Int(data.phraseId), isMarked)
        }
    }

    func showAnimation() {
        dialogContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        dialogContainerView.alpha = 0
        self.isHidden = false

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.dialogContainerView.transform = .identity
            self.dialogContainerView.alpha = 1
        }
    }

    func dismiss() {
        performDismissAnimation()
    }

    @objc private func dismiss(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: dialogContainerView)
        if !dialogContainerView.bounds.contains(location) {
            performDismissAnimation()
        }
    }

    private func performDismissAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dialogContainerView.alpha = 0
            self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
            self.alpha = 1
        })
    }
}
