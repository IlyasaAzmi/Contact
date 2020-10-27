//
//  ContactViewModel.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import Foundation
import Combine

class ContactViewModel: ObservableObject {
    @Published var loading = false
    @Published var contacts: [Contact] = []
    
    var cancellationToken: AnyCancellable?
    
    init() {
        getContacts()
    }
}

extension ContactViewModel {
    
    func getContacts() {
        self.loading = true
        cancellationToken = ContactDB.request(.generalRandomGames)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.contacts = $0.data.contacts
                    self.loading = false
                  })
    }
    
    func sortArray(property: String, additional: String) -> [Contact] {
        if property == SortProperties.name.rawValue {
            if additional == SortAdditional.descending.rawValue {
                return contacts.sorted { $0.name > $1.name}
            } else {
                return contacts.sorted { $0.name < $1.name}
            }
        } else if property == SortProperties.email.rawValue {
            if additional == SortAdditional.descending.rawValue {
                return contacts.sorted { $0.email > $1.email}
            } else {
                return contacts.sorted { $0.email < $1.email}
            }
        } else if property == SortProperties.phone.rawValue {
            if additional == SortAdditional.descending.rawValue {
                return contacts.sorted { $0.phoneNumber! > $1.phoneNumber!}
            } else {
                return contacts.sorted { $0.phoneNumber! < $1.phoneNumber!}
            }
        } else if property == SortProperties.date.rawValue {
            if additional == SortAdditional.descending.rawValue {
                return contacts.sorted { $0.createdAt > $1.createdAt}
            } else {
                return contacts.sorted { $0.createdAt < $1.createdAt}
            }
        } else {
            return contacts
        }
    }
}


