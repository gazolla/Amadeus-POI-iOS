//
//  Auth.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 18/08/22.
//

import Foundation

class Auth: Codable {
    var type: String?
    var username: String?
    var application_name: String?
    var client_id: String?
    var token_type: String?
    var access_token: String?
    var expires_in: Int?
    var state: String?
    var scope: String?
    
    enum CodingKeys: String, CodingKey {
            case access_token
    }

    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try values.decode(String.self, forKey: .access_token)
    }
    
}
