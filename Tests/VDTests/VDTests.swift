import XCTest
import UIKit
@testable import VDKit

final class VDTests: XCTestCase {
	
	func collectionTests() {
		var array = [1, 2, 3]
		XCTAssert(array[safe: 0] == 1)
		XCTAssert(array[safe: 3] == nil)
		array[safe: 0] = 0
		XCTAssert(array == [0, 2, 3])
		array[safe: 1] = nil
		XCTAssert(array == [0, 3])
		array[safe: 2] = 1
		XCTAssert(array == [0, 3, 1])
	}
	
	func dateTests() {
		
	}
	
	func chainTests() {
		let button = UIButton().chain
			.layer.cornerRadius[43]
			.titleLabel.font[.systemFont(ofSize: 43)]
			.backgroundColor[.red]
			.tintColor[.black]
			.clipsToBounds[true]
			.isHidden[false]
			.isUserInteractionEnabled[true]
			.titleEdgeInsets[.zero]
			.alpha[4]
			.frame.size[.zero]
	}
	
	static var allTests = [
		("collectionTests", collectionTests),
		("dateTests", dateTests),
		("chainTests", chainTests),
	]
	
}
