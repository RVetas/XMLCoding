# **XMLCoding**

### Encoding

#### Usage

Here is an example of `XMLEncoder` usage. For given input:

```swift
enum Habit: String, Encodable {
	case sports
	case videogames
	case music
	case movies
	case series
}

struct Person: Encodable {
	let age: UInt
	let name: String
	let habits: [Habit]
}

let value = Person(
	age: 25,
	name: "Vitaliy",
	habits: [
		.movies,
		.music,
		.sports
	]
)

let xmlEncoder = XMLEncoder()
let result = try! xmlEncoder.encode(value)
```

the result will be:

```xml
<person type="Person">
        <age>25</age>
        <name>Vitaliy</name>
        <habits type="Array" elementType="Habit">
                <item type="Habit">
                            movies
                </item>
                <item type="Habit">
                            music
                </item>
                <item type="Habit">
                            sports
                </item>
        </habits>
</person>
```

#### Customization

XMLEncoder can receive two customizable properties in its `init` method:

```Swift
public final class XMLEncoder {
  public init(
		configuration: XMLEncodingConfiguration = XMLEncodingConfiguration.default,
		attributesWorker: BuildsAttributesString = AttributesStringBuilder()
	)
  
  ...
}
```

The first property `configuration` of type `XMLEncodingConfiguration` allows you to customize the number of spaces in indents, the root element name (type name is used by default) and whether encoder should include type attributes or not. Example outputs for different configurations can be found [here](./Tests/XMLCodingTests/__Snapshots__/XMLEncoderTests/testCustomConfiguration.1.txt) and [here](./Tests/XMLCodingTests/__Snapshots__/XMLEncoderTests/testCustomConfiguration.2.txt).

`BuildsAttributesString` is an interface that allows encoder to insert attributes for encoded values. `AttributesStringBuilder` is a default implementation of this protocol that, it adds `type` and `elementType` attributes as shown above. 
