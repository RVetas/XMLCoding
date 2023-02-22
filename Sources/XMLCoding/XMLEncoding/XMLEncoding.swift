// Created by Рамазанов Виталий Глебович on 20/02/23

final class XMLEncoding: Encoder {
	
	var codingPath: [CodingKey] = []
	var userInfo: [CodingUserInfoKey : Any] = [:]
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	
	let encodingContext: XMLEncodingContext
	
	init(
		encodingContext: XMLEncodingContext = XMLEncodingContext(),
		indentationLevel: UInt,
		configuration: XMLEncodingConfiguration
	) {
		self.encodingContext = encodingContext
		self.indentationLevel = indentationLevel
		self.configuration = configuration
	}
	
	func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
		let xmlcontainer = XMLKeyedEncodingContainer<Key>(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
		let container = KeyedEncodingContainer(xmlcontainer)
		return container
	}
	
	func unkeyedContainer() -> UnkeyedEncodingContainer {
		XMLUnkeyedEncodingContainer(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel,
			configuration: configuration
		)
	}
	
	func singleValueContainer() -> SingleValueEncodingContainer {
		XMLSingleValueEncodingContainer(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
	}
}
