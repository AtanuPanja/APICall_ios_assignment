//
//  APICodable.swift
//  ios_assignment_api_call
//
//  Created by promact on 12/02/24.
//

import Foundation

struct APIsObject: Codable {
    let entries: [APIItem]
}

struct APIItem: Codable {
    let api: String
    let description: String
    let link: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case api = "API"
        case description = "Description"
        case link = "Link"
        case category = "Category"
    }
}
