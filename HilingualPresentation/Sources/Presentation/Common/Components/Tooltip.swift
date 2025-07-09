//
//  Tooltip.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/9/25.
//

import UIKit

final class Tooltip: UIView {
    
    // MARK: - UI Components

    var tooltipText: String {
        return tooltipLabel.text ?? ""
    }
    
    private let tooltip: UIView = {
        let view = UIView()
        view.backgroundColor = .hilingualBlack
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let tooltipLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_m_12)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let triangleView = TriangleView()
    
    // MARK: - LifeCycle
    
    init(_ text: String) {
        super.init(frame: .zero)
        tooltipLabel.text = text
        setUI()
        setLayout()
        dismissTooltip()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setUI() {
        tooltip.addSubview(tooltipLabel)
        addSubviews(tooltip, triangleView)
    }
    
    private func setLayout() {
        tooltip.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(31)
        }
        
        tooltipLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(tooltip).inset(8)
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
        
        triangleView.snp.makeConstraints {
            $0.top.equalTo(tooltip.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(13)
            $0.height.equalTo(7)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func dismissTooltip() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}

final class TriangleView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width: CGFloat = 13
        let height: CGFloat = 7
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.hilingualBlack.cgColor
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        layer.addSublayer(shapeLayer)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 13, height: 7)
    }
}
// MARK: - Preview

@available(iOS 17.0, *)
fileprivate final class TooltipPreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let tooltip = Tooltip("10자 이상 작성해야 피드백 요청이 가능해요!")

        view.addSubview(tooltip)
        tooltip.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    TooltipPreviewViewController()
}
