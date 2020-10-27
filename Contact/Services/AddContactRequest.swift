//
//  AddContactRequest.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 26/10/20.
//

import Foundation
import Combine
import SwiftUI

class HttpAuth: ObservableObject {

    @Published var isLoading = false

    func postAuth(name: String, email: String, phoneNumber: Int) {
        
        self.isLoading = true
        guard let url = URL(string: "https://rest-api-cloud-functions.firebaseapp.com/api/v1/contacts") else { return }
        
        let apiKey = "qOfUHjuBFAXD412l2CrOnAjlOO3j8V74"
        
        let body: [String: Any] = [
            "name": name,
            "email": email,
            "phoneNumber": phoneNumber
        ]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let dataString = String(data: data, encoding: .utf8)
                let jsondata = dataString?.data(using: .utf8)
                let result = try JSONDecoder().decode(AddContactResponse.self, from: jsondata!)
                print(result)
                print(result.status)
                
                if result.status == "success" {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } catch let err {
                print(err)
            }
            
        }.resume()
  }

}
