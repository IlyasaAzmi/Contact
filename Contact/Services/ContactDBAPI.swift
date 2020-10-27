//
//  ContactDBAPI.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import Foundation
import Combine

enum ContactDB {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://rest-api-cloud-functions.firebaseapp.com/api/v1/")!
    static let apiKey = "qOfUHjuBFAXD412l2CrOnAjlOO3j8V74"
}

enum APIPath: String {
    case generalRandomGames = "contacts"
}

extension ContactDB {
    
    static func request(_ path: APIPath) -> AnyPublisher<ContactResponse, Error> {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
}
