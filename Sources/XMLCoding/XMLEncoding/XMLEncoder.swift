// Created by Рамазанов Виталий Глебович on 20/02/23

/// XMLEncoder allows user to encode Encodable values into XML string
public final class XMLEncoder {
	
	private let indentationLevel: UInt
	private let configuration: XMLEncodingConfiguration
	private let isRoot: Bool
	private let attributesWorker: BuildsAttributesString
	
	/// XMLEncoder initialize method
	/// - Parameters:
	/// 	- configuration: Encoding configuration that allows user to customize XML output
	/// 	- attributesWorker: Worker that handles attributes for Encodable types, default implementation adds `type` and `elementType` (only for Collections) attributes to each item
	public init(
		configuration: XMLEncodingConfiguration = XMLEncodingConfiguration.default,
		attributesWorker: BuildsAttributesString = AttributesStringBuilder()
	) {
		self.indentationLevel = 0
		self.configuration = configuration
		self.isRoot = true
		self.attributesWorker = attributesWorker
	}
	
	init(
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
	
	/// This function allows you to encode an Encodable `value` into XML-String
	///
	///	The basic example of usage:
	///	```swift
	///	enum Habit: String, Encodable {
	/// 	case sports
	/// 	case videogames
	/// 	case music
	/// 	case movies
	/// 	case series
	/// }
	///
	/// struct Person: Encodable {
	///    let age: UInt
	///    let name: String
	///    let habits: [Habit]
	/// }
	///
	/// let value = Person(
	///    age: 25,
	///    name: "Vitaliy",
	///    habits: [
	/// 	   .movies,
	/// 	   .music,
	/// 	   .sports
	///    ]
	/// )
	///
	/// let xmlEncoder = XMLEncoder()
	/// let result = try! xmlEncoder.encode(value)
	///	```
	/// Will result into:
	/// ```xml
	/// <person type="Person">
	/// 	<age>25</age>
	///  	<name>Vitaliy</name>
	///  	<habits type="Array" elementType="Habit">
	/// 		 <item type="Habit">
	/// 					 movies
	/// 		 </item>
	/// 		 <item type="Habit">
	/// 					 music
	/// 		 </item>
	/// 		 <item type="Habit">
	/// 					 sports
	/// 		 </item>
	///  	</habits>
	/// </person>
	/// ```
	///
	/// - Returns: String with XML output
	/// - Throws: EncodingError
	public func encode(_ value: Encodable) throws -> String {
		let encoder = XMLEncoding(indentationLevel: indentationLevel + 1, configuration: configuration)
		try value.encode(to: encoder)
		let xmlString = encoder.encodingContext.data
		if isRoot {
			let attributes = attributesWorker.getAttributesString(for: value)
			switch configuration.rootElementName {
				case .default:
					let rootName = attributesWorker.getTypeString(for: value)
					return "<\(rootName) \(attributes)>\n\(xmlString)\n</\(rootName)>"
				case .custom(let rootElementName):
					if configuration.shouldIncludeAttributes {
						return "<\(rootElementName) \(attributes)>\n\(xmlString)\n</\(rootElementName)>"
					} else {
						return "<\(rootElementName)>\n\(xmlString)\n</\(rootElementName)>"
					}
			}
		}
		
		return "\(xmlString)\n"
	}
}
