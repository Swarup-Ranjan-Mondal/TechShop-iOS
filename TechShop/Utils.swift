//
//  Utils.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 16/01/21.
//

import SwiftUI
import Alamofire

let serverURL = "http://localhost:5000"

func getImageDataFromURL(_ imageURL: String) -> Data? {
    if let url = URL(string: imageURL) {
        if let imageData = try? Data(contentsOf: url) {
            return imageData
        }
    }
    
    return nil
}

func uploadFileHandler(_ imageData: Data, completionHandler: @escaping (String) -> Void) {
    AF.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image" , fileName: "product.png" , mimeType: "image/png")
        },
        to: "\(serverURL)/api/upload"
    )
    .response(completionHandler: { result in
        if let data = result.data {
            completionHandler(String(data: data, encoding: .utf8)!)
        } else if let error = result.error {
            print(error.errorDescription!)
        }
    })
}

func textFieldValidatorEmail(_ string: String) -> Bool {
    if string.count > 100 {
        return false
    }
    let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: string)
}

func getFirstName(_ name: String) -> String {
    var firstName: String = name
    if let index = name.firstIndex(of: " ") {
        firstName = String(name[..<index])
    }
    return firstName
}

func formatDateString(dateString: String, format: String) -> String {
    if let date = stringToDate(date: dateString) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    return dateString
}

func getImageFromData(data: Data) -> Image? {
    if let uiImage = UIImage(data: data) {
        return Image(uiImage: uiImage)
    }
    
    return nil
}

private func stringToDate(date: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let parsedDate = formatter.date(from: date) {
        return parsedDate
    }
    
    return nil
}
