// Created by Рамазанов Виталий Глебович on 20/02/23


import XCTest
import SnapshotTesting

@testable import XMLCoding

final class XMLEncoderTests: XCTestCase {
	var encoder: XMLEncoder!
	var isRecordMode: Bool = false
	
	override func setUp() {
		encoder = XMLEncoder()
	}
	
	func testValueEncoding() {
		TestData.ValueEncoding.values.forEach {
			assertSnapshots(matching: try! encoder.encode($0), as: [.lines], record: isRecordMode)
		}
	}
	
	func testArrayEncoding() {
		TestData.ArrayEncoding.values.forEach {
			assertSnapshots(matching: try! encoder.encode($0), as: [.lines], record: isRecordMode)
		}
	}
	
	/* TODO: - Make up a working test
	Apparently, dictionary does not save the order while encoding,
	so this test has _some_ chance to success.
	 
	 
	func testDictionaryEncoding() {
		TestData.DictionaryEncoding.values.forEach {
			assertSnapshots(matching: try! encoder.encode($0), as: [.lines], record: false)
		}
	}
	 */
	
	func testComplexObjectsEncoding() {
			assertSnapshots(matching: try! encoder.encode(TestData.ComplexObjectsEncoding.value), as: [.lines], record: isRecordMode)
	}
	
	func testArrayOfComplexObjectsEncoding() {
		assertSnapshots(matching: try! encoder.encode(TestData.ArrayOfComplexObjectsEncoding.values), as: [.lines], record: isRecordMode)
	}
	
	func testCustomConfiguration() {
		encoder = XMLEncoder(configuration: XMLEncodingConfiguration(countOfIndentationSpaces: 1, rootElementName: .custom("body")))
		assertSnapshots(matching: try! encoder.encode(TestData.ArrayOfComplexObjectsEncoding.values), as: [.lines], record: isRecordMode)
	}
	
	func testArrayOfArraysEncoding() {
		assertSnapshots(matching: try! encoder.encode(TestData.ArrayOfArraysEncoding.value), as: [.lines], record: isRecordMode)
	}
}

private extension XMLEncoderTests {
	enum TestData {
		enum ValueEncoding {
			static let values: [Encodable] = [
				5 as Int,
				.pi as Float,
				.pi as Double,
				"Hello world!"
			]
		}
		
		enum ArrayEncoding {
			static let values: [Encodable] = [
				Array<Int>(arrayLiteral: 1, 2, 3, 4, 5),
				[1.25, 0.3, .zero, .pi] as [Float],
				[1.25, 0.3, .zero, .pi] as [Double],
				["Hello", "World", "!"]
			]
		}
		
		enum DictionaryEncoding {
			static let values: [Encodable] = [
				["Key1": 1, "Key2": 2] as [String: Int],
				[1: "Value1", 2: "Value2"] as [Int: String]
			]
		}
		
		enum ComplexObjectsEncoding {
			struct Object: Encodable {
				struct NestedObject: Encodable {
					let property: String
					let arrayProperty: [String]
				}
				
				let value: String
				let array: [Int]
				let nestedObject: NestedObject
			}
			
			static let value: Object = Object(
				value: "Hi",
				array: [1, 2, 3],
				nestedObject: Object.NestedObject(
					property: "Hello World!",
					arrayProperty: ["ArrayValue1", "ArrayValue2"]
				)
			)
		}
		
		enum ArrayOfComplexObjectsEncoding {
			static let values = [ComplexObjectsEncoding.Object](
				repeating: ComplexObjectsEncoding.value,
				count: 3
			)
		}
		
		enum ArrayOfArraysEncoding {
			static let value = [
				[1, 2, 3, 4, 5],
				[5, 4, 3, 2, 1]
			]
		}
	}
}
