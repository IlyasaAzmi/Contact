//
//  ContactResponse.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import Foundation

// MARK: - ContactResponse
struct ContactResponse: Codable {
    let status: String
    let messages: [String]
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let contacts: [Contact]
}

// MARK: - Contact
struct Contact: Codable {
    let name, email: String
    let phoneNumber: String?
    let createdAt: Double
    
    private enum CodingKeys: String, CodingKey {
        case name, email
        case createdAt
        case phoneNumber = "phoneNumber"
    }
    init(phoneNumber: String? = nil, name: String, email: String, createdAt: Double) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.createdAt = createdAt
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        createdAt = try container.decode(Double.self, forKey: .createdAt)
        do {
            phoneNumber = try String(container.decode(Int.self, forKey: .phoneNumber))
        } catch DecodingError.typeMismatch {
            phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        }
    }
}

extension Contact: Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        if lhs.name != rhs.name {
            return lhs.name < rhs.name
        } else if lhs.email != rhs.email {
            return lhs.email < rhs.email
        } else if lhs.phoneNumber != rhs.phoneNumber {
            return lhs.phoneNumber! < rhs.phoneNumber!
        } else {
            return lhs.createdAt < rhs.createdAt
        }
    }
    
    static func > (lhs: Contact, rhs: Contact) -> Bool {
        if lhs.name != rhs.name {
            return lhs.name > rhs.name
        } else if lhs.email != rhs.email {
            return lhs.email > rhs.email
        } else if lhs.phoneNumber != rhs.phoneNumber {
            return lhs.phoneNumber! > rhs.phoneNumber!
        } else {
            return lhs.createdAt > rhs.createdAt
        }
    }
}
