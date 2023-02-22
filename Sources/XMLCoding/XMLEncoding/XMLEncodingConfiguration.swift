// Created by Рамазанов Виталий Глебович on 20/02/23

public struct XMLEncodingConfiguration {
	public enum RootElementName {
		case `default`
		case custom(String)
	}
	public let countOfIndentationSpaces: UInt
	public let rootElementName: RootElementName
	
	public init(countOfIndentationSpaces: UInt, rootElementName: RootElementName) {
		self.countOfIndentationSpaces = countOfIndentationSpaces
		self.rootElementName = rootElementName
	}
	
	public func indentation(level: UInt) -> String {
		return String(repeating: " ", count: Int(countOfIndentationSpaces * level))
	}
	
	public static var `default`: XMLEncodingConfiguration {
		XMLEncodingConfiguration(countOfIndentationSpaces: 4, rootElementName: .default)
	}
}
