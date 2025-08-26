//
//  SharedDiaryView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/21/25.
//

import UIKit
import SnapKit

final class SharedDiaryView: BaseUIView {
    
    // MARK: - Properties
    
    var onProfileAction: (() -> Void)?
    var onLikeAction: ((Bool) -> Void)?
    
    // MARK: - UI Components
    
    private let profileView: SharedProfileView = {
        let profileView = SharedProfileView()
        return profileView
    }()
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setUI
    
    override func setUI() {
        addSubviews(profileView)
        
        profileView.configure(profileImageURL: "https://avatars.githubusercontent.com/u/42905243?v=4", nickname: "가나디", streak: 15, sharedDateMinutes: 127, isLiked: true, likeCount: 7)
        
        profileView.onProfileTapped = { [weak self] in
            self?.onProfileAction?()
        }

        profileView.onLikeToggled = { [weak self] isLiked in
            self?.onLikeAction?(isLiked)
        }
    }
    
    override func setLayout() {
        profileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
