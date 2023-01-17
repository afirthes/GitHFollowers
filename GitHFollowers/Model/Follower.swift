//
//  Folloser.swift
//  GitHFollowers
//
//  Created by Afir Thes on 12.09.2022.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String

    // custom hash func
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.login)
    }
}
