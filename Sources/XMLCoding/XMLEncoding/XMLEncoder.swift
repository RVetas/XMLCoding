// Created by Рамазанов Виталий Глебович on 20/02/23

public final class XMLEncoder {
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	private let isRoot: Bool
	private let attributesWorker: BuildsAttributesString
	
	public init(
		indentationLevel: UInt = 0,
		configuration: XMLEncodingConfiguration = XMLEncodingConfiguration.default,
		isRoot: Bool = true,
		attributesWorker: BuildsAttributesString = AttributesStringBuilder()
	) {
		self.indentationLevel = indentationLevel
		self.configuration = configuration
		self.isRoot = isRoot
		self.attributesWorker = attributesWorker
	}
	
	public func encode(_ value: Encodable) throws -> String {
		let encoder = XMLEncoding(indentationLevel: indentationLevel + 1, configuration: configuration)
		try value.encode(to: encoder)
		let xmlString = encoder.encodingContext.data
		
		if isRoot {
			switch configuration.rootElementName {
				case .default:
					return "<root \(attributesWorker.getAttributesString(for: value))>\n\(xmlString)\n</root>"
				case .custom(let rootElementName):
					return "<\(rootElementName)>\n\(xmlString)\n</\(rootElementName)>"
			}
		}
		
		return "\(xmlString)\n"
	}
}
