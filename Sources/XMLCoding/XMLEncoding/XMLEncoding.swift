// Created by Рамазанов Виталий Глебович on 20/02/23

public final class XMLEncoding: Encoder {
	
	public var codingPath: [CodingKey] = []
	public var userInfo: [CodingUserInfoKey : Any] = [:]
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	
	let encodingContext: XMLEncodingContext
	
	public init(
		encodingContext: XMLEncodingContext = XMLEncodingContext(),
		indentationLevel: UInt,
		configuration: XMLEncodingConfiguration
	) {
		self.encodingContext = encodingContext
		self.indentationLevel = indentationLevel
		self.configuration = configuration
	}
	
	public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
		let xmlcontainer = XMLKeyedEncodingContainer<Key>(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
		let container = KeyedEncodingContainer(xmlcontainer)
		return container
	}
	
	public func unkeyedContainer() -> UnkeyedEncodingContainer {
		XMLUnkeyedEncodingContainer(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel,
			configuration: configuration
		)
	}
	
	public func singleValueContainer() -> SingleValueEncodingContainer {
		XMLSingleValueEncodingContainer(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
	}
}
