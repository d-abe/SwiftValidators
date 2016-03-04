import Foundation
import SwiftyJSON

public class ValidationWithMessage {
	private let validation: Validation
	private let message: String

	init(message: String, validation: Validation) {
		self.message = message
		self.validation = validation
	}

	public func validate(data: String) -> (Bool, String?) {
		if validation(data) {
			return (true, nil)
		}
		return (false, message)
	}
}

public class ValidationSet {

	private var json: JSON?
	private var postData: [String:String]?

	private enum DataType {
		case Json, Post
	}

	private var type: DataType
	private var validations: [String:[ValidationWithMessage]] = [String:[ValidationWithMessage]]()

	public init(_ json: JSON) {
		self.json = json
		self.type = .Json
		setup()
	}

	public init(_ postData: [String:String]) {
		self.postData = postData
		self.type = .Post
		setup()
	}

  public func setup() {
  	fatalError("Must be overridden")
  }

  private func getData(key: String) -> String {
    if self.type == .Json, let json = self.json {
    	return json[key].stringValue ?? ""
    } else if self.type == .Post, let postData = self.postData {
    	return postData[key] ?? ""
    }
  	return ""
  }

	public func validate() -> (Bool, [String]) {
		var result: Bool = true
		var errors: [String] = []
		for (key, validationArray) in validations {
			let data = getData(key)
			for validation in validationArray {
				let (ret, msg) = validation.validate(data)
				if !ret {
					result = false
					errors.append(msg!)
				}
			}
		}
		return (result, errors)
	}

  public func add(key: String, _ message: String, _ validation: Validation) {
		var array = validations[key]
		if array == nil {
			array = [ValidationWithMessage]()
		}
		array!.append(ValidationWithMessage(message: message, validation: validation))
		validations[key] = array!
	}

	public func contains(key: String, _ message: String, _ value: String) {
		self.add(key, message, Validator.contains(value))
	}

	public func equals(key: String, _ message: String, _ value: String) {
		self.add(key, message, Validator.equals(value))
	}

	public func exactLength(key: String, _ message: String, _ length: Int) {
		self.add(key, message, Validator.exactLength(length))
	}

	public func isASCII(key: String, _ message: String) {
		self.add(key, message, Validator.isASCII)
	}

	public func isAfter(key: String, _ message: String, _ date: String) {
		self.add(key, message, Validator.isAfter(date))
	}

	public func isAfter(key: String, _ message: String, _ date: String, dateFormat: String) {
		let validator = Validator(validationMode: .Default, dateFormat: dateFormat)
		self.add(key, message, validator.isAfter(date))
	}

	public func isAlpha(key: String, _ message: String) {
		self.add(key, message, Validator.isAlpha)
	}

	public func isAlphanumeric(key: String, _ message: String) {
		self.add(key, message, Validator.isAlphanumeric)
	}

	public func isBase64(key: String, _ message: String) {
		self.add(key, message, Validator.isBase64)
	}

	public func isBefore(key: String, _ message: String, _ date: String) {
		self.add(key, message, Validator.isBefore(date))
	}

	public func isBefore(key: String, _ message: String, _ date: String, dateFormat: String) {
		let validator = Validator(validationMode: .Default, dateFormat: dateFormat)
		self.add(key, message, validator.isBefore(date))
	}

	public func isBool(key: String, _ message: String) {
		self.add(key, message, Validator.isBool)
	}

	public func isCreditCard(key: String, _ message: String) {
		self.add(key, message, Validator.isCreditCard)
	}

	public func isDate(key: String, _ message: String) {
		self.add(key, message, Validator.isDate)
	}

	public func isEmail(key: String, _ message: String) {
		self.add(key, message, Validator.isEmail)
	}

	public func isEmpty(key: String, _ message: String) {
		self.add(key, message, Validator.isEmpty)
	}

	public func isFQDN(key: String, _ message: String,
		 _ options: Validator.FQDNOptions = Validator.FQDNOptions.defaultOptions) {
		self.add(key, message, Validator.isFQDN(options))
	}

	public func isFalse(key: String, _ message: String) {
		self.add(key, message, Validator.isFalse)
	}

	public func isFloat(key: String, _ message: String) {
		self.add(key, message, Validator.isFloat)
	}

	public func isHexColor(key: String, _ message: String) {
		self.add(key, message, Validator.isHexColor)
	}

	public func isHexadecimal(key: String, _ message: String) {
		self.add(key, message, Validator.isHexadecimal)
	}

	public func isIP(key: String, _ message: String) {
		self.add(key, message, Validator.isIP)
	}

	public func isIPv4(key: String, _ message: String) {
		self.add(key, message, Validator.isIPv4)
	}

	public func isIPv6(key: String, _ message: String) {
		self.add(key, message, Validator.isIPv6)
	}

	public func isISBN(key: String, _ message: String, _ version: String) {
		self.add(key, message, Validator.isISBN(version))
	}

	public func isIn(key: String, _ message: String, _ array: Array<String>) {
		self.add(key, message, Validator.isIn(array))
	}

	public func isInt(key: String, _ message: String) {
		self.add(key, message, Validator.isInt)
	}

	public func isLowercase(key: String, _ message: String) {
		self.add(key, message, Validator.isLowercase)
	}

	public func isMongoId(key: String, _ message: String) {
		self.add(key, message, Validator.isMongoId)
	}

	public func isNumeric(key: String, _ message: String) {
		self.add(key, message, Validator.isNumeric)
	}

	public func isPhone(key: String, _ message: String, _ locale: String) {
		self.add(key, message, Validator.isPhone(locale))
	}

	public func isTrue(key: String, _ message: String) {
		self.add(key, message, Validator.isTrue)
	}

	public func isUUID(key: String, _ message: String) {
		self.add(key, message, Validator.isUUID)
	}

	public func isUppercase(key: String, _ message: String) {
		self.add(key, message, Validator.isUppercase)
	}

	public func maxLength(key: String, _ message: String, _ length: Int) {
		self.add(key, message, Validator.maxLength(length))
	}

	public func minLength(key: String, _ message: String, _ length: Int) {
		self.add(key, message, Validator.minLength(length))
	}

	public func watch(key: String, _ message: String, _ delegate: ValidatorProtocol) {
		self.add(key, message, Validator.watch(delegate))
	}

	public func required(key: String, _ message: String) {
		self.add(key, message, Validator.required)
	}
}
