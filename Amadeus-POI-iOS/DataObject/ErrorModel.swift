//
//  ErrorModel.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 18/08/22.
//

import Foundation

struct ErrorModel: Codable{
    let errors:[AmadeusError]?
}

struct AmadeusError: Codable, Identifiable {
    var id = UUID()
    var status:Int?
    var code:Int?
    var title:String?
    var detail:String?
    var source:Source
    
    enum CodingKeys: String, CodingKey {
        case status, code, title, detail, source
    }
}

struct Source:Codable{
    var parameters:[String]?
}


struct AmadeusTokenError: Codable, Identifiable {
    var id = UUID()
    var error:String?
    var error_description:String?
    var code:Int?
    var title:String?
    
    enum CodingKeys: String, CodingKey {
        case error, error_description, code, title
    }
}
