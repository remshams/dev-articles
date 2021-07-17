//
//  Date.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 03.06.21.
//

import Foundation
extension ISO8601DateFormatter {
  convenience init(_ formatOptions: Options) {
    self.init()
    self.formatOptions = formatOptions
  }
}

extension Formatter {
  static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withFullDate,
                                                                  .withTime,
                                                                  .withDashSeparatorInDate,
                                                                  .withColonSeparatorInTime,
                                                                  .withTimeZone])
}

extension DateFormatter {
  static var simpleDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
  }()
}

extension String {
  var iso8601Date: Date? {
    Formatter.iso8601withFractionalSeconds.date(from: self)
  }
}

extension Date {
  var iso8601String: String {
    Formatter.iso8601withFractionalSeconds.string(from: self)
  }
}
