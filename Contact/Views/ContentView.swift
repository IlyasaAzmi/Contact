//
//  ContentView.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import SwiftUI

struct ContentView: View {
    @State var presentingModal = false
    @State var presentingModalSort = false
    @State var modalIsDisplayed = false
    @ObservedObject var viewModel = ContactViewModel()
    @EnvironmentObject var settings: UserSettings
    
    let gradient = Gradient(colors: [.black, .pink])
    
    var body: some View {
        LoadingView(isShowing: $viewModel.loading) {
            NavigationView{
                List{
                    ForEach(viewModel.sortArray(property: settings.selectedProperty, additional: settings.selectedAdditional), id: \.name) { contact in
                        ZStack{
                            ContactRow(contact: contact)
                            NavigationLink(destination: DetailContactView(contact: contact)) {
                                EmptyView()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Contacts")
                .navigationBarItems(leading: Button(action: {
                    self.presentingModalSort = true
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .foregroundColor(.pink)
                .sheet(isPresented: $presentingModalSort) { SortView(presentedAsModal: self.$presentingModalSort) }, trailing: Button(action: {
                    self.presentingModal = true
                }) {
                    Image(systemName: "person.badge.plus.fill")
                }
                .foregroundColor(.pink)
                .sheet(isPresented: $presentingModal) { AddContactView(presentedAsModal: self.$presentingModal) })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContactRow: View {
    var contact : Contact
    var contentColor = Color.pink
    
    var phone : String?
    
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.pink)
                Text(contact.name.getAcronyms())
                    .fontWeight(.bold)
                    .font(.body)
                    .foregroundColor(.white)
            }
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(contact.name)
                        .font(.headline)
                    Text(contact.email)
                        .font(.caption)
                        .lineLimit(1)
                    Text(contact.phoneNumber ?? "")
                        .font(.caption)
                    Text("\(getDateTime(date: contact.createdAt))")
                        .font(.caption2)
                }
                .padding()
            }
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
