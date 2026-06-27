//
//  DebugForceErrorViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

// DEBUG 전용. 화면별로 강제 에러(끔/서버/데이터없음/네트워크)를 런타임 토글하는 화면.

#if DEBUG
import UIKit
import SnapKit
import HilingualCore

public final class DebugForceErrorViewController: UIViewController {

    private let errorOptions: [(title: String, error: HilingualError?)] = [
        ("끔", nil), ("서버", .server), ("데이터없음", .dataNotFound), ("네트워크", .network)
    ]
    private let failCountOptions = [1, 5, 99]

    private let scrollView = UIScrollView()
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        return stack
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "강제 에러"
        setupLayout()
        buildRows()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        contentStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }

    private func buildRows() {
        contentStack.addArrangedSubview(makeFailCountRow())
        contentStack.addArrangedSubview(makeAllOffButton())
        contentStack.addArrangedSubview(separator())

        for (index, testCase) in NetworkDebug.testCases.enumerated() {
            contentStack.addArrangedSubview(makeCaseRow(testCase, index: index))
        }
    }

    // MARK: - Rows

    private func makeCaseRow(_ testCase: NetworkDebug.TestCase, index: Int) -> UIView {
        let label = UILabel()
        label.text = testCase.label
        label.font = .pretendard(.body_m_16)
        label.setContentHuggingPriority(.required, for: .horizontal)

        let segmented = UISegmentedControl(items: errorOptions.map { $0.title })
        segmented.tag = index
        segmented.selectedSegmentIndex = currentSelectedIndex(for: testCase.path)
        segmented.addTarget(self, action: #selector(caseChanged(_:)), for: .valueChanged)

        let row = UIStackView(arrangedSubviews: [label, segmented])
        row.axis = .vertical
        row.spacing = 6
        row.alignment = .fill
        return row
    }

    private func makeFailCountRow() -> UIView {
        let label = UILabel()
        label.text = "강제 실패 횟수 (이후 실제 호출 → 재시도 복구)"
        label.font = .pretendard(.cap_r_12)
        label.textColor = .gray500

        let segmented = UISegmentedControl(items: failCountOptions.map { "\($0)" })
        segmented.selectedSegmentIndex = failCountOptions.firstIndex(of: NetworkDebug.maxFailCount) ?? 0
        segmented.addTarget(self, action: #selector(failCountChanged(_:)), for: .valueChanged)

        let row = UIStackView(arrangedSubviews: [label, segmented])
        row.axis = .vertical
        row.spacing = 6
        return row
    }

    private func makeAllOffButton() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle("전체 끄기", for: .normal)
        button.titleLabel?.font = .pretendard(.body_m_16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .hilingualBlack
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(allOffTapped), for: .touchUpInside)
        button.snp.makeConstraints { $0.height.equalTo(44) }
        return button
    }

    private func separator() -> UIView {
        let line = UIView()
        line.backgroundColor = .gray200
        line.snp.makeConstraints { $0.height.equalTo(1) }
        return line
    }

    // MARK: - Actions

    @objc private func caseChanged(_ sender: UISegmentedControl) {
        let testCase = NetworkDebug.testCases[sender.tag]
        let error = errorOptions[sender.selectedSegmentIndex].error
        if let error {
            NetworkDebug.forcedErrors[testCase.path] = error
        } else {
            NetworkDebug.forcedErrors[testCase.path] = nil
        }
        NetworkDebug.resetFailCounts()
    }

    @objc private func failCountChanged(_ sender: UISegmentedControl) {
        NetworkDebug.maxFailCount = failCountOptions[sender.selectedSegmentIndex]
        NetworkDebug.resetFailCounts()
    }

    @objc private func allOffTapped() {
        NetworkDebug.forcedErrors.removeAll()
        NetworkDebug.resetFailCounts()
        contentStack.arrangedSubviews
            .compactMap { ($0 as? UIStackView)?.arrangedSubviews.compactMap { $0 as? UISegmentedControl }.first }
            .forEach { seg in
                if seg.numberOfSegments == errorOptions.count {
                    seg.selectedSegmentIndex = 0
                }
            }
    }

    // MARK: - Helpers

    private func currentSelectedIndex(for path: String) -> Int {
        guard let error = NetworkDebug.forcedErrors[path] else { return 0 }
        return errorOptions.firstIndex(where: { $0.error == error }) ?? 0
    }
}
#endif
