//
//  ProductionCompany.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
