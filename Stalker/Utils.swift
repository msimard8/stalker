//
//  Utils.swift
//  Stalker
//
//  Created by Michael Simard on 5/6/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static let stalkerNameKey = "stalker-name"

    static var stalkerName: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: stalkerNameKey)
        }
        get {
            return UserDefaults.standard.value(forKey: stalkerNameKey) as? String ?? ""
        }
    }

    static func formatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let formmattedDate = dateFormatter.date(from: date) {
            print (formmattedDate)
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "en_US")
            displayFormatter.dateFormat = "MMM d, YYYY, h:mm a"
            return displayFormatter.string(from: formmattedDate)
        }
        return ""
    }
}
