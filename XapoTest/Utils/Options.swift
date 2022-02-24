//
//  Options.swift
//  XapoTest
//
//  Created by Olivier on 2/16/22.
//

import Foundation
import UIKit

let xapoLightGray = UIColor(red: 146/255.0, green: 146/255.0, blue: 156/255.0, alpha: 1.0)
let xapoDarkGray = UIColor(red: 114/255.0, green: 119/255.0, blue: 128/255.0, alpha: 1.0)

// format Int to K's (1100 --> 1.1K)
extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)B"

    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)M"

    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)K"

    case 0...:
        return "\(n)"

    default:
        return "\(sign)\(n)"
    }
}

func utcToLocal(dateStr: String) -> String? {
    var dateStrvar = dateStr
    dateStrvar.removeLast()
    // create dateFormatter with UTC time format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = dateFormatter.date(from: dateStrvar)// create   date from string
    
    // change to a readable time format and change to local time zone
    dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
    dateFormatter.timeZone = NSTimeZone.local
    let timeStamp = dateFormatter.string(from: date!)
    return timeStamp
}
