import Foundation
import XCTest
@testable import dev_articles

class InMemoryArticlesDbTests: XCTestCase {
  
  let article = createArticleFixture()
  var db: InMemoryArticlesDb!
  
  override func setUp() {
    db = InMemoryArticlesDb()
  }
  
  func testList$_ShouldEmitNothingWhenNoArticleHasBeenStored() -> Void {
    
  }
  
}
