//
//  HomeView.swift
//  Hilingual
//
//  Created by 조영서 on 7/9/25.
//

import UIKit
import SnapKit

final class HomeView: BaseUIView {
    
    // MARK: - UI Components
    
    private let headerView = CalendarHeaderView()
    private let calendarView = CalendarView()
    private let selectedDateView = SelectedDateView()
    private let cardTopicView = CardTopicView()
    //private let cardPreview = CardPreview()
    private let selectedInfo = SelectedInfo()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "하링이"
        label.font = .suit(.head_b_18)
        label.textColor = .white
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let totalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_bubble_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "총 15편"
        label.font = .suit(.caption_m_12)
        label.textColor = .white
        return label
    }()
    
    private let dot: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let streakImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_fire_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let streakLabel: UILabel = {
        let label = UILabel()
        label.text = "6일 연속 작성 중"
        label.font = .suit(.caption_m_12)
        label.textColor = .white
        return label
    }()
    
    private let profileStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        return stack
    }()
    
    private let statusStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
//    private let emptyDiaryLabel: UILabel = {
//        let label = UILabel()
//        label.text = "작성된 일기가 없어요.\n좋은 하루 보내셨기를 바라요!"
//        label.font = .suit(.body_sb_14)
//        label.textColor = .gray400
//        label.numberOfLines = 2
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private let emptyDiaryView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "img_diary_empty_ios", in: .module, compatibleWith: nil)
//        return imageView
//    }()
//    
//    private let emptyDiaryStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.spacing = 8
//        stack.alignment = .center
//        stack.backgroundColor = .white
//        return stack
//    }()
    
    private let diaryLockLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성 가능한 시간이 아니에요.\n오늘의 일기를 작성해주세요!"
        label.font = .suit(.body_sb_14)
        label.textColor = .gray400
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let diaryLockView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_diary_lock_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let diaryLockStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.backgroundColor = .white
        return stack
    }()
    
    // MARK: - Custom Method
        
    override func setUI() {
        
        backgroundColor = .hilingualBlack
        
        addSubviews(
            profileImageView,
            profileStack,
            headerView,
            calendarView,
            divider,
            selectedDateView,
            selectedInfo
            //emptyDiaryStack
        )
        
        profileStack.addArrangedSubviews(
            nameLabel,
            statusStack)
        
        statusStack.addArrangedSubviews(
            totalImageView,
            totalLabel,
            dot,
            streakImageView,
            streakLabel)
        
//        emptyDiaryStack.addArrangedSubviews(
//            emptyDiaryView,
//            emptyDiaryLabel)
    
        diaryLockStack.addArrangedSubviews(
            diaryLockView,
            diaryLockLabel)
    }
        
    override func setLayout() {
        
        dot.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 2, height: 2))
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(46)
        }
        
        profileStack.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
                
        headerView.snp.makeConstraints {
            $0.top.equalTo(profileStack.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        selectedInfo.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
//      emptyDiaryStack.snp.makeConstraints {
//        $0.top.equalTo(selectedDateView.snp.bottom)
//        $0.horizontalEdges.equalToSuperview()
//        $0.bottom.equalToSuperview()
//        }
    }
}

#Preview {
    HomeView()
}
