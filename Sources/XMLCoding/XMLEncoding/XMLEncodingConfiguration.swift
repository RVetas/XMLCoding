// Created by Рамазанов Виталий Глебович on 20/02/23

public struct XMLEncodingConfiguration {
	public let countOfIndentationSpaces: UInt
	
	public init(countOfIndentationSpaces: UInt) {
		self.countOfIndentationSpaces = countOfIndentationSpaces
	}
	
	public func indentation(level: UInt) -> String {
		return String(repeating: " ", count: Int(countOfIndentationSpaces * level))
	}
}
