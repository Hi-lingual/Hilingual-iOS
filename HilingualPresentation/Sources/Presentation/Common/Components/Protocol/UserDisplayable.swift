//
//  UserDisplayable.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/22/25.
//

protocol UserDisplayable {
    var userId: Int { get }
    var profileImg: String { get }
    var nickname: String { get }
    var buttonState: FollowButtonState { get }
}
