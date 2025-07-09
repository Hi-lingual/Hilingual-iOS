//
//  DiaryDetailUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

import Combine

public protocol DiaryDetailUseCase {
    func fetchDiaryDetail(diaryId: Int64) -> AnyPublisher<DiaryDetailEntity, Error>
    func setBookmark(phraseId: Int64) -> AnyPublisher<PhraseEntity,Error>
}

public final class DefaultDiaryDetailUseCase: DiaryDetailUseCase {
    private let diaryDetailRepository: DiaryDetailRepository
    private let bookmarkRepository: BookmarkRepository
    
    public init(diaryDetailRepository: DiaryDetailRepository ,bookmarkRepository: BookmarkRepository) {
        self.diaryDetailRepository = diaryDetailRepository
        self.bookmarkRepository = bookmarkRepository
    }
    
    
    // TODO: - 다른 뷰 연결 시 해당 id 넘어오도록 구현
    
    public func fetchDiaryDetail(diaryId: Int64) -> AnyPublisher<DiaryDetailEntity, Error> {
        return diaryDetailRepository.fetchDiaryDetail(diaryId: 111)
    }
    
    public func setBookmark(phraseId: Int64) -> AnyPublisher<PhraseEntity,Error> {
        return bookmarkRepository.setBookmark(phraseId: 111)
    }
}
