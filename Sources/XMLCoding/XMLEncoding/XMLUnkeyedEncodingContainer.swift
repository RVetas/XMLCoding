// Created by Рамазанов Виталий Глебович on 20/02/23

final class XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
	
	var codingPath: [CodingKey]
	var count: Int = 0
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	private let attributesWorker: BuildsAttributesString
	
	private var indentation: String {
		configuration.indentation(level: indentationLevel)
	}
	
	private let encodingContext: XMLEncodingContext
	
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
	
	func encodeNil() throws {}
	
	func encode<T>(_ value: T) throws where T: Encodable & LosslessStringConvertible {
		encodingContext.data.append("\(indentation)<item>\(String(value))</item>")
		count += 1
	}
	
	func encode<T>(_ value: T) throws where T : Encodable {
		let nestedEncoder = XMLEncoder(indentationLevel: indentationLevel + 1, configuration: configuration, isRoot: false)
		let stringValue = try nestedEncoder.encode(value)
		count += 1
		
		if configuration.shouldIncludeAttributes {
			let attributes = attributesWorker.getAttributesString(for: value)
			encodingContext.data.append("\(indentation)<item \(attributes)>\n\(stringValue)\(indentation)</item>\n")
		} else {
			encodingContext.data.append("\(indentation)<item>\n\(stringValue)\(indentation)</item>\n")
		}
		
	}
	
	func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
		KeyedEncodingContainer(
			XMLKeyedEncodingContainer<NestedKey>(
				encodingContext: encodingContext,
				codingPath: codingPath,
				indentationLevel: indentationLevel + 1,
				configuration: configuration
			)
		)
	}
	
	func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		XMLUnkeyedEncodingContainer(
			encodingContext: encodingContext,
			codingPath: codingPath,
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
