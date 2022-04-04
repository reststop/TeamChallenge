//
//  Team.swift
//  TeamChallenge
//
//  Created by carl on 4/3/22.
//

import Foundation
import UIKit

struct Member {
    var id: Int
    var firstName: String
    var lastName: String
    var title: String
    var bio: String
    var avatar: String
}

final class Team {

    private static var members: [Member] = []

    // use a set to insure no duplicate entries
    private static var pictures = Set<String>()

    class func initialize() {

        guard let json = Bundle.main.url(forResource: "team", withExtension: "json") else {
            return
        }
        switch (Result {
            try JSONDecoder().decode([[String:String]].self, from: try Data(contentsOf: json))
        }) {
        case .success(let entries):
            Team.members = []
            Team.pictures = Set<String>()
            for dict in entries {
                let entry = Member(id: Int(dict["id"] ?? "0")!,
                                   firstName: dict["firstName"] ?? "",
                                   lastName: dict["lastName"] ?? "",
                                   title: dict["title"] ?? "",
                                   bio: dict["bio"] ?? "",
                                   avatar: dict["avatar"] ?? ""
                )
                Team.members.append(entry)
                Team.pictures.insert(entry.avatar)
                TeamImage.preload(entry.avatar)
            }
        case .failure(_):
            break
        }
    }

    class func getMember() -> Member? {
        if Team.members.count > 0 {
            return Team.members.randomElement()!
        }
        return nil
    }

    // get 5 more images avoiding duplicates
    class func getImageURLs(_ member: Member) -> [String] {
        var images = Set<String>()
        images.insert(member.avatar)
        var imageURLs: [String] = []
        while imageURLs.count < 5 {
            let random = Team.pictures.randomElement()!
            if images.contains(random) {
                continue
            }
            imageURLs.append(random)
            images.insert(random)
        }
        return imageURLs
    }

}
