// Created by Рамазанов Виталий Глебович on 22/02/23

import Foundation

public protocol BuildsAttributesString {
	func getAttributesString(for value: Encodable) -> String
}

public final class AttributesStringBuilder: BuildsAttributesString {
	public init() { }
	
	public func getAttributesString(for value: Encodable) -> String {
		if let value = value as? any Collection {
			return "type=\"\(sanitize(string: value.collectionType))\" elementType=\"\(sanitize(string: value.elementType))\""
		}
		
		return "type=\"\(type(of: value))\""
	}
	
	private func sanitize(string: String) -> String {
		var string = string
		if let index = string.firstIndex(of: "<") {
			string.removeSubrange(index ..< string.endIndex)
		}
		return string
	}
}

fileprivate extension Collection {
	var collectionType: String {
		"\(type(of: self))"
	}

	var elementType: String {
		"\(type(of: Element.self))".replacingOccurrences(of: ".Type", with: "")
	}
}
