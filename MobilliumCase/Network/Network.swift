//
//  Network.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 15.09.2022.
//

import Foundation
struct Network {
    
    static let shared = Network()

    func request<T: Decodable>(urlType : urlType,page : Int, completion: @escaping (Result<T, CustomError>) -> Void) {

        guard let url = URL(string: generatedURL(num: page,urlType: urlType) ) else {
            Logger.log(text: "url oluşturulamadı!")
            return
        }
        Logger.log(type: .info, text: "URL" + url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
        let session = URLSession.shared

        session.dataTask(with: request) { data, response, error in

            guard let data = data else {
                completion(.failure(CustomError(message: "data oluşturulamadı")))
                return
            }
            Logger.log(type: .info, text: String(data: data, encoding: .utf8.self) ?? "")

            let decoder = JSONDecoder()

            do {
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            }
            catch let error {
                print("denemeee",String(describing: error))
                completion(Result.failure(CustomError(message: error.localizedDescription)))
            }

        }.resume()
    }
    
    
    func generatedURL(num: Int,urlType: urlType) -> String {
        var url : String = ""
        switch urlType {
        case .slider:
            url = UrlParts.baseURLNowPlaying.rawValue + ApiKeys.ApiKeyOne.rawValue + UrlParts.language.rawValue + Languages.eng.rawValue + UrlParts.page.rawValue + num.toString
        case .list:
            url = UrlParts.baseURLUpComing.rawValue + ApiKeys.ApiKeyOne.rawValue + UrlParts.language.rawValue + Languages.eng.rawValue + UrlParts.page.rawValue + num.toString
        case .detail:
            url = UrlParts.baseURL.rawValue + num.toString + UrlParts.questionMark.rawValue + UrlParts.apiKeyText.rawValue + ApiKeys.ApiKeyOne.rawValue
        }
        return url
    }
  
}
struct CustomError: Error {
    let message: String
}

