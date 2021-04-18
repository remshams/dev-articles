//
//  Configuration.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 18.04.21.
//

import Foundation

enum Configuration {
  case release
  case debug
  case test
}

#if TEST
let configuration = Configuration.test
#elseif DEBUG
let configuration = Configuration.debug
#else
let configuration = Configuration.release
#endif
