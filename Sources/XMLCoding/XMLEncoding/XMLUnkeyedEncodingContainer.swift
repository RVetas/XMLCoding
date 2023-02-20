// Created by Рамазанов Виталий Глебович on 20/02/23

public final class XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
	
	public var codingPath: [CodingKey]
	public var count: Int = 0
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	
	private var indentation: String {
		configuration.indentation(level: indentationLevel)
	}
	
	private let encodingContext: XMLEncodingContext
	
	public init(
		encodingContext: XMLEncodingContext,
		codingPath: [CodingKey],
		indentationLevel: UInt,
		configuration: XMLEncodingConfiguration
	) {
		self.encodingContext = encodingContext
		self.codingPath = codingPath
		self.indentationLevel = indentationLevel
		self.configuration = configuration
	}
	
	public func encodeNil() throws {}
	
	public func encode<T>(_ value: T) throws where T: Encodable & LosslessStringConvertible {
		encodingContext.data.append("\(indentation)<item>\(String(value))</item>")
		count += 1
	}
	
	public func encode<T>(_ value: T) throws where T : Encodable {
		let nestedEncoder = XMLEncoder(indentationLevel: indentationLevel + 1, configuration: configuration, isRoot: false)
		let stringValue = try nestedEncoder.encode(value)
		count += 1
		encodingContext.data.append("\(indentation)<item>\n\(stringValue)\(indentation)</item>\n")
	}
	
	public func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
		KeyedEncodingContainer(
			XMLKeyedEncodingContainer<NestedKey>(
				encodingContext: encodingContext,
				codingPath: codingPath,
				indentationLevel: indentationLevel + 1,
				configuration: configuration
			)
		)
	}
	
	public func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		XMLUnkeyedEncodingContainer(
			encodingContext: encodingContext,
			codingPath: codingPath,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
	}
	
	public func superEncoder() -> Encoder {
		XMLEncoding(
			encodingContext: encodingContext,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
	}
}
