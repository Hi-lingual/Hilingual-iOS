//
//  VocaViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation

public final class VocaViewController: BaseUIViewController<VocaViewModel> {
    
    private let vocaView = VocaView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureDummyCards()
    }
    
    public override func setUI() {
        view.addSubview(vocaView)
    }
    
    public override func setLayout() {
        vocaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureDummyCards() {
        let dummyCards: [(PhraseData, WordCardType)] = [
            (
                PhraseData(
                    phraseId: 111,
                    phraseType: ["동사", "명사"],
                    phrase: "resonate with",
                    explanation: "~와 깊이 공감되다, 마음에 와닿다",
                    example: nil,
                    isMarked: false,
                    created_at: nil
                ),
                .basic
            ),
            (
                PhraseData(
                    phraseId: 112,
                    phraseType: ["동사", "숙어"],
                    phrase: "come across as",
                    explanation: "~처럼 보이다, ~한 인상을 주다",
                    example: "“My life comes across as a disaster.”처럼 자신이나 상황의 ‘이미지’를 묘사할 때 자연스러워요.",
                    isMarked: true,
                    created_at: nil
                ),
                .withExample
            ),
            (
                PhraseData(
                    phraseId: 112,
                    phraseType: ["동사", "숙어"],
                    phrase: "come across as",
                    explanation: "~처럼 보이다, ~한 인상을 주다",
                    example: "“My life comes across as a disaster.”처럼 자신이나 상황의 ‘이미지’를 묘사할 때 자연스러워요.",
                    isMarked: true,
                    created_at: nil
                ),
                .withExample
            ),
            (
                PhraseData(
                    phraseId: 112,
                    phraseType: ["동사", "숙어"],
                    phrase: "come across as",
                    explanation: "~처럼 보이다, ~한 인상을 주다",
                    example: "“My life comes across as a disaster.”처럼 자신이나 상황의 ‘이미지’를 묘사할 때 자연스러워요.",
                    isMarked: true,
                    created_at: nil
                ),
                .withExample
            ),
            (
                PhraseData(
                    phraseId: 112,
                    phraseType: ["동사", "숙어"],
                    phrase: "come across as",
                    explanation: "~처럼 보이다, ~한 인상을 주다",
                    example: "“My life comes across as a disaster.”처럼 자신이나 상황의 ‘이미지’를 묘사할 때 자연스러워요.",
                    isMarked: true,
                    created_at: nil
                ),
                .withExample
            ),
            (
                PhraseData(
                    phraseId: 113,
                    phraseType: ["동사"],
                    phrase: "act up",
                    explanation: "말썽 부리다",
                    example: nil,
                    isMarked: true,
                    created_at: "2025.07.06"
                ),
                .withExample
            )
        ]
        
        vocaView.configure(with: dummyCards)
    }
}
