// Created by Рамазанов Виталий Глебович on 22/02/23

import Foundation

/// This protocol declares an interface that is used by XMLEncoder and its containers to create attributes for given value
public protocol BuildsAttributesString {
	func getAttributesString(for value: Encodable) -> String
}

/// AttributesStringBuilder is a default implementation of BuildsAttributesString, it creates `type` and `elementType` attributes for given value using its type and type of its elements (for Collections).
public final class AttributesStringBuilder: BuildsAttributesString {
	
	/// AttributesStringBuilder initializer. This implementation has no dependencies and this `init` does nothing.
	public init() { }
	
	/// This method allows user to get attributes for given value
	/// - Returns: a string with `type` attribute for given value (e.g. Int for value of type Int), and `elementType` attributes, if given value is a collection
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
