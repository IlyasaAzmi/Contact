//
//  SortView.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import SwiftUI

struct SortView: View {
    @Binding var presentedAsModal: Bool
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    RadioButtonGroupsProperties { selected in
                        print("Selected Property is: \(selected)")
                        self.settings.selectedProperty = selected
                    }
                    .padding(.vertical, 20)
                    RadioButtonGroupsAscDesc { selected in
                        print("Selected Additional is: \(selected)")
                        self.settings.selectedAdditional = selected
                    }
                    Button(action: {
                        print("Apply!")
                        self.presentedAsModal = false
                    }) {
                        Text("Apply")
                            .fontWeight(.semibold)
                            .font(.body)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(18)
                    }
                    .padding(.top, 20)
                    Button(action: {
                        print("Reset Tapped")
                        self.settings.selectedProperty = ""
                        self.settings.selectedAdditional = ""
                    }) {
                        Text("Reset")
                            .foregroundColor(.pink)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarTitle("Sort", displayMode: .inline)
        }
    }
}

//MARK:- Single Radio Button Field
struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 18,
        isMarked: Bool = false,
        callback: @escaping (String)->()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .frame(width: 30, height: 20)
                    .foregroundColor(isMarked ? .pink : .black)
                Text(label)
                    .font(Font.system(size: textSize))
                Spacer()
            }.foregroundColor(self.color)
            .padding(.vertical, 5)
        }
        .foregroundColor(Color.white)
    }
}

//MARK:- Group of Radio Buttons
enum SortProperties: String {
    case name = "Name"
    case email = "Email"
    case phone = "Phone"
    case date = "Date"
}

struct RadioButtonGroupsProperties: View {
    let callback: (String) -> ()
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Properties")
            radioNameSort
            radioEmailSort
            radioPhoneSort
            radioDateSort
        }
        .environmentObject(settings)
    }
    
    var radioNameSort: some View {
        RadioButtonField(
            id: SortProperties.name.rawValue,
            label: SortProperties.name.rawValue,
            isMarked: settings.selectedProperty == SortProperties.name.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioEmailSort: some View {
        RadioButtonField(
            id: SortProperties.email.rawValue,
            label: SortProperties.email.rawValue,
            isMarked: settings.selectedProperty == SortProperties.email.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioPhoneSort: some View {
        RadioButtonField(
            id: SortProperties.phone.rawValue,
            label: SortProperties.phone.rawValue,
            isMarked: settings.selectedProperty == SortProperties.phone.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioDateSort: some View {
        RadioButtonField(
            id: SortProperties.date.rawValue,
            label: SortProperties.date.rawValue,
            isMarked: settings.selectedProperty == SortProperties.date.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        settings.selectedProperty = id
        callback(id)
    }
}

//MARK:- Group of Radio Buttons
enum SortAdditional: String {
    case ascending = "Ascending"
    case descending = "Descending"
}

struct RadioButtonGroupsAscDesc: View {
    let callback: (String) -> ()
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Additional")
            radioAscendingSort
            radioDescendingSort
        }
    }
    
    var radioAscendingSort: some View {
        RadioButtonField(
            id: SortAdditional.ascending.rawValue,
            label: SortAdditional.ascending.rawValue,
            isMarked: settings.selectedAdditional == SortAdditional.ascending.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioDescendingSort: some View {
        RadioButtonField(
            id: SortAdditional.descending.rawValue,
            label: SortAdditional.descending.rawValue,
            isMarked: settings.selectedAdditional == SortAdditional.descending.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        settings.selectedAdditional = id
        callback(id)
    }
}


