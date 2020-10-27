//
//  DetailContactView.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import SwiftUI

struct DetailContactView: View {
    var contact: Contact
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            List{
                HStack{
                    Spacer()
                    ZStack{
                        Circle()
                            .frame(width: 100, height: 100, alignment: .center)
                            .foregroundColor(.pink)
                            .padding()
                        Text(getAcronyms(name: contact.name))
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                
                HStack{
                    Image(systemName: "person.fill")
                        .foregroundColor(.pink)
                    Spacer()
                    Text(contact.name)
                }
                HStack{
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.pink)
                    Spacer()
                    Text(contact.email)
                }
                HStack{
                    Image(systemName: "phone.fill")
                        .foregroundColor(.pink)
                    Spacer()
                    Text("\(contact.phoneNumber ?? "")")
                }
                HStack{
                    Image(systemName: "calendar")
                        .foregroundColor(.pink)
                    Spacer()
                    Text("\(getDateTime(date: contact.createdAt))")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Detail")
        }
    }
    
    func getAcronyms(name: String) -> String {
        return name.getAcronyms()
    }
    
    func getDateTime(date: Double) -> String {
        let epochTime = TimeInterval(date) / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(epochTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = NSTimeZone() as TimeZone
        let localDate = dateFormatter.string(from: date as Date)
        
        return localDate
    }
}
