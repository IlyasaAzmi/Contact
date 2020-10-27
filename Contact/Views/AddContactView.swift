//
//  AddContactView.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 24/10/20.
//

import SwiftUI

struct Background<Content: View>: View {
    private var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Color.white
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .overlay(content)
    }
}

struct AddContactView: View {
    @Binding var presentedAsModal: Bool
    @State private var enableLogging = false
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var isEmailValid : Bool = true
    @State private var isNameValid : Bool = true
    @State private var isPhoneValid : Bool = true
    
    @State private var isValidData : Bool = false
    
    @ObservedObject var manager = HttpAuth()
    
    var body: some View {
        Background{
            LoadingView(isShowing: $manager.isLoading) {
                NavigationView {
                    Form {
                        Section(header: Text("NAME"), footer: Text("At least 6 characters")) {
                            TextField("Username", text: $name, onEditingChanged: { (isChanged) in
                                if !isChanged {
                                    if self.checkName(self.name) {
                                        self.isNameValid = true
                                    } else {
                                        self.isNameValid = false
                                        self.name = ""
                                    }
                                    getValidationData()
                                }
                            })
                            if !self.isNameValid {
                                Text("Name at least 6 characters")
                                    .font(.callout)
                                    .foregroundColor(Color.red)
                            }
                            
                        }
                        Section(header: Text("EMAIL"), footer: Text("Must be valid email")) {
                            TextField("Email", text: $email, onEditingChanged: { (isChanged) in
                                if !isChanged {
                                    if self.textFieldValidatorEmail(self.email) {
                                        self.isEmailValid = true
                                    } else {
                                        self.isEmailValid = false
                                        self.email = ""
                                    }
                                    getValidationData()
                                }
                            })
                            .font(.headline)
                            .autocapitalization(.none)
                            
                            if !self.isEmailValid {
                                Text("Email is Not Valid")
                                    .font(.callout)
                                    .foregroundColor(Color.red)
                            }
                        }
                        Section(header: Text("PHONE"), footer: Text("At least 8 characters")) {
                            TextField("Phone Number", text: $phoneNumber, onEditingChanged: { (isChanged) in
                                if !isChanged {
                                    if self.phoneNumberValidation(self.phoneNumber) {
                                        self.isPhoneValid = true
                                    } else {
                                        self.isPhoneValid = false
                                        self.phoneNumber = ""
                                    }
                                    getValidationData()
                                }
                            })
                            .keyboardType(.numberPad)
                            
                            if !self.isPhoneValid {
                                Text("Phone Number at least 8 digits numbers")
                                    .font(.footnote)
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                    
                    
                    .navigationBarTitle("Add Contact")
                    .navigationBarItems(leading: HStack {
                        Button("Cancel") {
                            self.presentedAsModal = false
                        }
                        .foregroundColor(.pink)
                    }, trailing:
                        HStack {
                            Button("Save") {
                                print("Save tapped!")
                                print("\(self.name), \(self.email), \(self.phoneNumber)")
                                
                                if self.name != "" && self.email != "" && self.phoneNumber != "" {
                                    self.manager.postAuth(name: self.name, email: self.email, phoneNumber: Int(self.phoneNumber)!)
                                    self.presentedAsModal = false
                                } else {
                                    print("Data Invalid")
                                }
                                
                                self.hideKeyboard()
                                
                            }
                            .disabled(!isValidData)
                            .foregroundColor(isValidData ? .pink : .gray)
                        }
                    )
                }
                .padding(.top, 18)
                .environmentObject(manager)
            }
            
        }
        .onTapGesture(count: 1, perform: {
            self.hideKeyboard()
        })
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        
        if string == "" {
            return false
        }
        
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    func checkName(_ string: String) -> Bool {
        if string.count < 6 {
            return false
        }
        
        return true
    }
    
    func phoneNumberValidation(_ value: String) -> Bool {
        if value.count < 8 {
            return false
        }
        
        return value.isInt
    }
    
    func getValidationData() {
        if isNameValid && isEmailValid && isPhoneValid {
            isValidData = true
        } else {
            isValidData = false
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
