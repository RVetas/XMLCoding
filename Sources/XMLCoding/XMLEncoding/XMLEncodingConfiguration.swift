// Created by Рамазанов Виталий Глебович on 20/02/23

/// Encoding configuration that allows user to customize XML output
public struct XMLEncodingConfiguration {
	public enum RootElementName {
		case `default`
		case custom(String)
	}
	
	/// This property allows user to customize the number of spaces used in indentation
	public let countOfIndentationSpaces: UInt
	/// This property allows user to customize the root element name
	public let rootElementName: RootElementName
	/// This property allows user to decide whether encoder should include type attributes or not
	public let shouldIncludeAttributes: Bool
	
	/// XMLEncodingConfiguration initialize method
	/// - Parameters:
	/// 	- counfOfIndentationSpaces: This property allows user to customize the number of spaces used in indentation
	/// 	- rootElementName: This property allows user to customize the root element name
	/// 	- shouldIncludeAttributes: This property allows user to decide whether encoder should include type attributes or not
	public init(
		countOfIndentationSpaces: UInt,
		rootElementName: RootElementName,
		shouldIncludeAttributes: Bool
	) {
		self.countOfIndentationSpaces = countOfIndentationSpaces
		self.rootElementName = rootElementName
		self.shouldIncludeAttributes = shouldIncludeAttributes
	}
	
	func indentation(level: UInt) -> String {
		return String(repeating: " ", count: Int(countOfIndentationSpaces * level))
	}
	
	/// Default configuration, it has 4 spaces in indentation, `root` as root element name and it includes type attributes in an output
	public static var `default`: XMLEncodingConfiguration {
		XMLEncodingConfiguration(
			countOfIndentationSpaces: 4,
			rootElementName: .default,
			shouldIncludeAttributes: true
		)
	}
}
