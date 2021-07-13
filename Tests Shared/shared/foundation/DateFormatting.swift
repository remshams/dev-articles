//
//  DateTest.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 13.07.21.
//

@testable import dev_articles
import Foundation
import XCTest

class DateFormattingTests: XCTestCase {
  let dateString = "2021-07-13T11:58:43Z"
  var date: Date!

  override func setUp() {
    let dateComponents = DateComponents(
      timeZone: TimeZone(abbreviation: "UTC"),
      year: 2021,
      month: 7,
      day: 13,
      hour: 11,
      minute: 58,
      second: 43
    )
    date = Calendar(identifier: .gregorian).date(from: dateComponents)
  }

  func test_iso8601Date_parsesString() {
    XCTAssertEqual(dateString.iso8601Date, date)
  }

  func test_iso8601Date_returnsNilWhenStringIsInvalid() {
    XCTAssertEqual("2021".iso8601Date, nil)
  }

  func test_iso8601String_convertsToDate() {
    XCTAssertEqual(date.iso8601String, dateString)
  }
}
