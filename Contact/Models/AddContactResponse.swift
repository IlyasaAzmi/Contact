//
//  AddContactResponse.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import Foundation

// MARK: - AddContactResponse
struct AddContactResponse: Codable {
    let status: String
    let message: [String]?
    let messages: [String]?
    let data: DataClassAdd?
}

// MARK: - DataClass
struct DataClassAdd: Codable {
    let contact: [ContactAdd]
}

// MARK: - Contact
struct ContactAdd: Codable {
    let name, email: String
    let phoneNumber, createdAt: Int
}

