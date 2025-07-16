//
//  LoadingView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/11/25.
//

import UIKit
import SnapKit

import Lottie

final class LoadingView: BaseUIView {
    
    enum State {
        case loading
        case success
        case error
    }
    
    // MARK: - Properties
    
    var onCloseTapped: (() -> Void)?
    
    private var startTime: Date?
    private var currentState: State = .loading
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_20)
        label.textColor = .gray850
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_r_18)
        label.textColor = .gray400
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .imgErrorIos)
        imageView.isHidden = true
        return imageView
    }()
    
    private let errorIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(resource: .icError16Ios)
        return icon
    }()
    
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 화면을 나가면, 작성 중인 일기가\n저장되지 않아요"
        label.font = .suit(.caption_r_12)
        label.textColor = .gray300
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let closeIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .icClose24BIos), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    let feedbackButton: CTAButton = {
        let button = CTAButton(style: .TextButton(""), autoBackground: true)
        button.isHidden = true
        button.isEnabled = true
        return button
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        addTarget()
        configure(for: .loading)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(titleLabel, subtitleLabel,
                    animationView, errorIcon, footerLabel,
                    closeIcon, feedbackButton, errorImageView)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(260)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        errorIcon.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(73)
            $0.size.equalTo(16)
            $0.centerX.equalToSuperview()
        }
        
        footerLabel.snp.makeConstraints {
            $0.top.equalTo(errorIcon.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        closeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57.5)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        feedbackButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        errorImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(175)
        }
    }
    
    private func addTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeIconTapped))
        closeIcon.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    
    func configure(for state: State) {
        currentState = state
        
        [titleLabel, subtitleLabel, animationView, errorIcon, footerLabel].forEach {
            $0.isHidden = false
        }
        
        [closeIcon, feedbackButton].forEach {
            $0.isHidden = true
        }
        
        animationView.removeFromSuperview()
        
        switch state {
        case .loading:
            titleLabel.text = "일기 저장중.."
            subtitleLabel.text = "피드백을 요청하고 있어요."
            animationView.animation = LottieAnimation.named("feedback1", bundle: .module)
            animationView.play()
            
            errorIcon.isHidden = false
            footerLabel.isHidden = false
            
        case .success:
            titleLabel.text = "AI 피드백 완료!"
            subtitleLabel.text = "틀린 부분을 고치고,\n더 나은 표현으로 수정했어요!"
            animationView.animation = LottieAnimation.named("feedback2", bundle: .module)
            animationView.play()
            
            errorIcon.isHidden = true
            footerLabel.isHidden = true
            closeIcon.isHidden = false
            feedbackButton.setTitle("피드백 보러가기", for: .normal)
            feedbackButton.isHidden = false
            
        case .error:
            titleLabel.text = "앗! 일시적인 오류가 발생했어요."
            subtitleLabel.isHidden = true
            
            errorImageView.isHidden = false
            
            errorIcon.isHidden = true
            footerLabel.isHidden = true
            closeIcon.isHidden = false
            feedbackButton.setTitle("다시 요청하기", for: .normal)
            feedbackButton.isHidden = false
        }
        
        addSubview(animationView)
        
        let topAnchor = (state == .error) ? titleLabel.snp.bottom : subtitleLabel.snp.bottom

        animationView.snp.remakeConstraints {
            $0.top.equalTo(topAnchor).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(180)
        }
    }
    
    @objc private func closeIconTapped() {
        onCloseTapped?()
    }
}

// MARK: - Preview

private final class LoadingPreviewViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

#Preview {
    LoadingPreviewViewController()
}
