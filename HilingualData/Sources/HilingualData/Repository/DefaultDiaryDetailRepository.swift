////
////  DefaultDiaryDetailRepository.swift
////  HilingualData
////
////  Created by 진소은 on 7/9/25.
////
//
//import Combine
//
//import HilingualDomain
//import HilingualNetwork
//
//public final class DefaultDiaryDetailRepository: DiaryDetailRepository {
//    private var service: DiaryDetailService
//    
//    public init(service: DiaryDetailService) {
//        self.service = service
//    }
//    
//    public func fetchDiaryDetail(diaryId: Int64) -> AnyPublisher<DiaryDetailEntity, any Error> {
//        let dummyEntity = DiaryDetailEntity(
//            code: 200,
//            data: nil,
//            message: "Dummy message"
//        )
//        return Just(dummyEntity)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//    }
//}
