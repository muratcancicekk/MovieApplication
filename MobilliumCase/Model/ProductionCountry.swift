//
//  ProductionCountry.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
