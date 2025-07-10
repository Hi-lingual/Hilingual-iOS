//
//  Modal.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/10/25.
//

import UIKit
import SnapKit

final class Modal: UIView {
    
    // MARK: - UI Components
    
    private let modalSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let modalLabel: UILabel = {
        let label = UILabel()
        label.text = "이미지 선택하기"
        label.font = .suit(.head_b_16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        self.addGestureRecognizer(tap)
    }
    
    private func setUI() {
        addSubview(modalSheetView)
        modalSheetView.addSubviews(modalLabel, stackView)
    }
    
    private func setLayout() {
        modalSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        modalLabel.snp.makeConstraints {
            $0.top.equalTo(modalSheetView).inset(24)
            $0.horizontalEdges.equalTo(modalSheetView).inset(16)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(modalLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(modalSheetView).inset(16)
            $0.bottom.equalTo(modalSheetView).inset(62)
        }
    }
    
    // MARK: - Public Methods
    
    public func setTitle(_ text: String) {
        modalLabel.text = text
    }
    
    public func configure(title: String, items: [(String, UIImage?, () -> Void)]) {
        modalLabel.text = title
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        items.forEach { (title, image, action) in
            let button = UIButton(type: .system)
            var config = UIButton.Configuration.plain()
            config.title = title
            config.image = image
            config.imagePadding = 8
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            button.configuration = config
            button.contentHorizontalAlignment = .leading
            button.addAction(UIAction { _ in action() }, for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Animation
    
    public func showAnimation() {
        modalSheetView.transform = CGAffineTransform(translationX: 0, y: modalSheetView.frame.height)
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.modalSheetView.transform = .identity
            self.backgroundColor = UIColor.dim
        }
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: self.modalSheetView.frame.height)
            self.backgroundColor = UIColor.dim.withAlphaComponent(0)
        }, completion: { _ in
            self.isHidden = true
        })
    }
}

// MARK: - Preview

final class ModalPreviewViewController: UIViewController {
    
    private let modal = Modal()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modal.configure(
            title: "이미지 선택",
            items: [
                ("카메라로 사진 찍기", UIImage(resource: .icCamera24Ios), {
                    print("카메라 선택")
                }),
                ("갤러리에서 선택하기", UIImage(resource: .icGallary24Ios), {
                    print("갤러리 선택")
                })
            ]
        )
        
        view.addSubview(modal)
        modal.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        modal.showAnimation()
    }
}

@available(iOS 17.0, *)
#Preview {
    ModalPreviewViewController()
}
