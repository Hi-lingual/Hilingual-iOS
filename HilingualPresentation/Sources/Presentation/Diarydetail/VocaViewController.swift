//
//  VocaViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation

public final class VocaViewController: BaseUIViewController<VocaViewModel> {
    
    // MARK: - Properties
    
    private let vocaView = VocaView()
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureDummyCards()
    }
    
    // MARK: Custom Method
    
    public override func setUI() {
        view.addSubview(vocaView)
    }
    
    public override func setLayout() {
        vocaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure

    private func configureDummyCards() {
        vocaView.configure(with: dummyCards)
    }
}
