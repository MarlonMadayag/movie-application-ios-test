//
//  MovieCredits.swift
//  MovieApplicationIOS
//
//  Created by Marlon Madayag on 1/20/21.
//

import Foundation

struct MovieCredits: Codable {
    let id: Int
    let cast: [Casts]
    let crew: [Crew]
}

struct Casts: Codable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Float
    let profile_path: String?
    let cast_id: Int
    let character: String
    let credit_id: String
    let order: Int
}

struct Crew: Codable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Float
    let profile_path: String?
    let credit_id: String
    let department: String
    let job: String
}
