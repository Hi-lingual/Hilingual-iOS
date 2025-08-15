//
//  FeedDiaryExampleViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/16/25.
//

import UIKit
import SnapKit

// MARK: - Mock Model
struct FeedDiaryItem {
    let nickname: String
    let profileImg: String?
    let streak: Int
    let sharedDateText: String
    let diaryPreviewText: String
}

// MARK: - ViewController
final class FeedDiaryExampleViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)

    // 더미 데이터
    private var items: [FeedDiaryItem] = [
        .init(
            nickname: "밍",
            profileImg: nil,
            streak: 3,
            sharedDateText: "2분 전",
            diaryPreviewText: "Had a presentation today and it went better than I expected. Learned a lot from the feedback."
        ),
        .init(
            nickname: "영서",
            profileImg: nil,
            streak: 0,
            sharedDateText: "어제",
            diaryPreviewText: "오늘은 비가 와서 집에서 책만 읽었다. 조용히 시간을 보내는 것도 나쁘지 않다."
        ),
        .init(
            nickname: "SOPT",
            profileImg: "https://picsum.photos/80",
            streak: 5,
            sharedDateText: "3일 전",
            diaryPreviewText: "Team sync went smoothly. Wrapped up the UI polish and started integrating the API."
        )
    ]

    private let emptyView = NoFeedView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setUI()
        setLayout()
        bindEmptyState()
    }

    // MARK: - Setup Methods
    private func setUI() {
        view.addSubview(tableView)

        tableView.register(FeedDiaryCell.self, forCellReuseIdentifier: FeedDiaryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140

        // 빈 상태 기본 문구
        emptyView.configure(message: "피드에 아직 공유된 일기가 없어요.")
        tableView.backgroundView = emptyView
    }

    private func setLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Private Methods
    private func bindEmptyState() {
        // items 변화에 따라 emptyView 노출 제어할 때 호출해주면 됨
        tableView.backgroundView?.isHidden = !items.isEmpty
    }
}

// MARK: - UITableViewDataSource
extension FeedDiaryExampleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bindEmptyState()
        return items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FeedDiaryCell.identifier,
            for: indexPath
        ) as? FeedDiaryCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(
            nickname: item.nickname,
            profileImageURL: item.profileImg,
            streak: item.streak,
            sharedDateText: item.sharedDateText,
            diaryPreviewText: item.diaryPreviewText
        )
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FeedDiaryExampleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 화면 이동 등 액션 배치
        print("Tapped row: \(indexPath.row)")
    }
}

// MARK: - Preview
#Preview {
    // 더미 데이터로 미리보기
    FeedDiaryExampleViewController()
}
