// Created by Рамазанов Виталий Глебович on 20/02/23

public final class XMLSingleValueEncodingContainer: SingleValueEncodingContainer {
	
	public var codingPath: [CodingKey] = []
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	private let encodingContext: XMLEncodingContext
	
	private var indent: String {
		configuration.indentation(level: indentationLevel)
	}
	
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
	
	public func encodeNil() throws { }

	public func encode<T>(_ value: T) throws where T: Encodable & LosslessStringConvertible {
		encodingContext.data.append("\(indent)\(String(value))")
	}
	
	public func encode<T>(_ value: T) throws where T : Encodable {
		let encoder = XMLEncoding(
			encodingContext: encodingContext,
			indentationLevel: indentationLevel + 1,
			configuration: configuration
		)
		try value.encode(to: encoder)
		encodingContext.data.append(encoder.encodingContext.data)
	}
}
