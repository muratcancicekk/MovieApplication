//
//  UrlParts.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation
enum UrlParts : String {
    case baseURL = "https://api.themoviedb.org/3/movie/"
    case baseURLNowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key="
    case baseURLUpComing = "https://api.themoviedb.org/3/movie/upcoming?api_key="
    case baseURLImage = "https://image.tmdb.org/t/p/w500"
    case questionMark = "?"
    case apiKeyText = "api_key="
    case language = "&language="
    case page = "&page="
    
}
