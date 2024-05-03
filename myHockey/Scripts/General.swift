//
//  General.swift
//  myHockey
//
//  Created by Brett Moxey on 9/4/2024.
//

import Foundation
import SwiftUI
func GetImage(teamName: String) -> String {
    var image: String = "*Default"
    if teamName == "HVLogo" {image = teamName}
    if teamName == "Nobody" {image = "HVLogo"}
    for club in clubs {
        if teamName.contains(club.clubName) {
            image = club.clubName
        }
        for other in club.otherNames ?? [] {
            if teamName.contains(other) {
                image = club.clubName
            }
        }
    }
    return image
}


func ShortTeamName(fullName: String) -> String {
    let newString = fullName.replacingOccurrences(of: " Hockey", with: "")
        .replacingOccurrences(of: " Club", with: "")
        .replacingOccurrences(of: " Association", with: "")
        .replacingOccurrences(of: " Sports INC", with: "")
        .replacingOccurrences(of: " Section", with: "")
        .replacingOccurrences(of: " United", with: " Utd")
        .replacingOccurrences(of: "Hockey ", with: "")
        .replacingOccurrences(of: "University", with: "Uni")
        .replacingOccurrences(of: "Eastern Christian Organisation (ECHO)", with: "ECHO")
        .replacingOccurrences(of: "Melbourne High School Old Boys", with: "MHSOB")
        .replacingOccurrences(of: "Greater ", with: "")
        .replacingOccurrences(of: "St Bede's", with: "St. Bede's")
        .replacingOccurrences(of: "Khalsas", with: "Khalsa")
    return newString
}


func ShortDivName(fullName: String) -> String {
    var newString = fullName.replacingOccurrences(of: "GAME Clothing ", with: "")
    if let firstFourDigits = Int(newString.prefix(4)), firstFourDigits > 1000 { newString.removeFirst(4) }
    if let lastFourDigits = Int(newString.suffix(4)), lastFourDigits > 1000 { newString.removeLast(4) }
    newString = newString.trimmingCharacters(in: .whitespaces)
        .trimmingCharacters(in: .punctuationCharacters)
        .trimmingCharacters(in: .whitespaces)
    return newString
}

func getDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    return dateFormatter.string(from: date)
}

func getColor(result: String) -> Color {
    var col: Color
    col = Color.white
    if result == "Win" { col = Color.green }
    if result == "Loss" { col = Color.red }
    if result == "Draw" { col = Color.yellow }
    if result == "No Game" { col = Color(UIColor.lightGray) }
    if result == "No Results" { col = Color(UIColor.lightGray) }
    if result == "BYE" { col = Color.cyan }
    return col
}

func getSymbol(result: String, roundNo: String, isCurrent: Bool) -> String {
    var text: String
    var bit: String
    text = "smallcircle.filled.circle.fill"
    if result == "No Game" && !isCurrent { bit = "" } else {bit = ".fill"}
    if roundNo.contains("Round ") {
        text = roundNo.replacingOccurrences(of: "Round ", with: "")
        text = "\(text).circle\(bit)"
    }
    if result == "BYE" { text = "hand.raised.circle.fill" }
    if roundNo.contains("Final") {text = "f.circle\(bit)"}
    if roundNo.contains("Semi Final") {text = "s.circle\(bit)"}
    if roundNo.contains("Quarter Final") {text = "q.circle\(bit)"}
    if roundNo.contains("Preliminary Final") {text = "p.circle\(bit)"}
    if roundNo.contains("Grand Final") {text = "trophy.circle\(bit)"}
    return text
}

func GetScores(scores: String, seperator: String) -> (String, String) {
    var homeScore = ""
    var awayScore = ""
    if scores.contains(seperator) {
        let myScores = scores.components(separatedBy: seperator)
        homeScore = myScores[0].trimmingCharacters(in: .whitespacesAndNewlines)
        awayScore = myScores[1].trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return (homeScore, awayScore)
}

func FixName(fullname: String) -> (String, String, Bool) {
    var myCap = false
    var myName = fullname
    if myName.contains(" (Captain)") {
        myCap = true
        myName = myName.replacingOccurrences(of: " (Captain)", with: "")
    }
    let mybits = myName.split(separator: ",")
    var surname = ""
    if mybits.count > 0 {
        surname = mybits[0].trimmingCharacters(in: .whitespaces).capitalized
        if surname.contains("'") {
            let mybits1 = surname.split(separator: "'")
            surname = mybits1[0].capitalized + "'" + mybits1[1].capitalized
        }
        let name = surname
        let surname = name.count >= 3 && name.lowercased().hasPrefix("mc") ? String(name.prefix(2)) + name[name.index(name.startIndex, offsetBy: 2)].uppercased() + String(name.suffix(from: name.index(after: name.index(name.startIndex, offsetBy: 2)))) : name
        if mybits.count > 1 {
            myName = mybits[1].trimmingCharacters(in: .whitespaces).capitalized + " " + surname
        }
    }
    return(myName, surname, myCap)
}

func GetStart(inputDate: String?) -> (String, Date) {
    var message: String = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E dd MMM yyyy HH:mm"
    
    guard let inputDate = inputDate,
          let startDate = dateFormatter.date(from: inputDate) else {
        message = "Invalid date"
        return (message, Date())
    }
    return (message, startDate)
}
