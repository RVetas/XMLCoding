// Created by Рамазанов Виталий Глебович on 20/02/23

final class XMLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
	
	var codingPath: [CodingKey]
	private let encodingContext: XMLEncodingContext
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	private let attributesWorker: BuildsAttributesString
	
	private var indent: String {
		configuration.indentation(level: indentationLevel)
	}
	
	init(
		encodingContext: XMLEncodingContext,
		codingPath: [CodingKey],
		indentationLevel: UInt,
		configuration: XMLEncodingConfiguration,
		attributesWorker: BuildsAttributesString = AttributesStringBuilder()
	) {
		self.encodingContext = encodingContext
		self.codingPath = codingPath
		self.indentationLevel = indentationLevel
		self.configuration = configuration
		self.attributesWorker = attributesWorker
	}
	
	func encodeNil(forKey key: Key) throws {}
	
	func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable & LosslessStringConvertible {
		codingPath.append(key)
		encodingContext.data.append("\(indent)<\(key.stringValue)>\(value)</\(key.stringValue)>\n")
	}
	
	func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
		codingPath.append(key)
		let nestedEncoder = XMLEncoder(indentationLevel: indentationLevel + 1, configuration: configuration, isRoot: false)
		let stringValue = try nestedEncoder.encode(value)
		if configuration.shouldIncludeAttributes {
			let attributes = attributesWorker.getAttributesString(for: value)
			encodingContext.data.append(
				"\(indent)<\(key.stringValue) \(attributes)>\n\(stringValue)\(indent)</\(key.stringValue)>\n"
			)
		} else {
			encodingContext.data.append(
				"\(indent)<\(key.stringValue)>\n\(stringValue)\(indent)</\(key.stringValue)>\n"
			)
		}
	}
	
	func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
		KeyedEncodingContainer(
			XMLKeyedEncodingContainer<NestedKey>(
				encodingContext: encodingContext,
				codingPath: codingPath,
				indentationLevel: indentationLevel + 1,
				configuration: configuration
			)
		)
	}
	
	func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
		XMLUnkeyedEncodingContainer(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
	}
	
	func superEncoder(forKey key: Key) -> Encoder {
		XMLEncoding(
			encodingContext: encodingContext,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
	}
	
	func superEncoder() -> Encoder {
		XMLEncoding(
			encodingContext: encodingContext,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
	}
}
