//
//  DateFormatter+Extension.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 10/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //"2017-01-15T11:16:11.000-08:00"
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"       //"2017-01-15T11:16:11.000Z"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
