//
//  String.swift
//  Contact
//
//  Created by Ilyasa' Azmi on 25/10/20.
//

import Foundation

extension String
{
    public func getAcronyms(separator: String = "") -> String
    {
        let acronyms = self.components(separatedBy: " ").map({ String($0.first!) }).joined(separator: separator);
        return acronyms;
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
}
