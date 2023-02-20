// Created by Рамазанов Виталий Глебович on 20/02/23

public final class XMLEncoder {
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	private let isRoot: Bool
	
	public init(
		indentationLevel: UInt = 0,
		configuration: XMLEncodingConfiguration = XMLEncodingConfiguration(countOfIndentationSpaces: 4),
		isRoot: Bool = true
	) {
		self.indentationLevel = indentationLevel
		self.configuration = configuration
		self.isRoot = isRoot
	}
	
	public func encode(_ value: Encodable) throws -> String {
		let encoder = XMLEncoding(indentationLevel: indentationLevel + 1, configuration: configuration)
		try value.encode(to: encoder)
		let xmlString = encoder.encodingContext.data
		
		if isRoot {
			return "<root>\n\(xmlString)\n</root>"
		}
		
		return "\(xmlString)\n"
	}
}
