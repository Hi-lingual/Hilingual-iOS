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
    let sharedDateMinutes: Int
    let diaryImg: String?
    let diaryPreviewText: String
    let likeCount: Int
    let isLiked: Bool
}

// MARK: - ViewController
final class FeedDiaryExampleViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)

    // 더미 데이터
    private var items: [FeedDiaryItem] = [
        .init(
            nickname: "영도리",
            profileImg: "https://ilovecharacter.com/news/data/20250501/p1065572674315832_650_thum.png",
            streak: 3,
            sharedDateMinutes: 0,
            diaryImg: "https://i.namu.wiki/i/9aUQQ4YjU9vmKuHT_cZAL61VKpKsLolynnI46BhOZQuKxGJygZ6BJK2zTHoX3pcNQmmcfzcVEZQcythY1lRXBQ.webp",
            diaryPreviewText: "Had a presentation today and it went better than I expected. Learned a lot from the feedbackHad a presentation today and it went better than I expected. Learned a lot from the feedbackHad a presentation today and it went better than I expected. Learned a lot from the feedbackHad a presentation today and it went better than I expected. Learned a lot from the feedbackHad a presentation today and it went better than I expected. Learned a lot from the feedback...",
            likeCount: 6,
            isLiked: true
        ),
        .init(
            nickname: "제로제로",
            profileImg: nil,
            streak: 0,
            sharedDateMinutes: 2,
            diaryImg: nil,
            diaryPreviewText: "듀라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라라",
            likeCount: 0,
            isLiked: false
        ),
        .init(
            nickname: "아요링",
            profileImg: "https://image.aladin.co.kr/Tobe/Thumbs/7AS4S2/Y3S223/638799314905503647_0.png?RS=600&FI=100",
            streak: 5,
            sharedDateMinutes: 2500,
            diaryImg: "https://mblogthumb-phinf.pstatic.net/MjAyMTA4MjJfMTYw/MDAxNjI5NTYwODY2MjI0.Vco-WmnxXlIRj08eYipQIVjzvUgeAGrIKZDSPmwvcnog.yzwYknZ2eUK5ZnNyz4nRSxXNoyPYDRC_a8RgPeqRCA8g.JPEG.chooddingg/output_4182079403.jpg?type=w800",
            diaryPreviewText: "​My beloved, Waiting for you who never comes, I am finally coming to you. From a very far away place, I am coming to you. After so many years, you are now coming. From a very far away place, you are still slowly approaching. While waiting for you, I am also going..",
            likeCount: 2,
            isLiked: false
        ),
        .init(
            nickname: "하링이",
            profileImg: nil,
            streak: 1,
            sharedDateMinutes: 11520,
            diaryImg: nil,
            diaryPreviewText: "바보",
            likeCount: 12,
            isLiked: true
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

        emptyView.configure(message: "피드에 아직 공유된 일기가 없어요.")
        tableView.backgroundView = emptyView
    }

    private func setLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Private Methods
    private func bindEmptyState() {
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
            sharedDateMinutes: item.sharedDateMinutes,
            diaryPreviewText: item.diaryPreviewText,
            diaryImageURL: item.diaryImg,
            isLiked: item.isLiked,
            likeCount: item.likeCount,
            isLast: indexPath.row == items.count - 1
        )
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FeedDiaryExampleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped row: \(indexPath.row)")
    }
}

// MARK: - Preview
#Preview {
    FeedDiaryExampleViewController()
}
