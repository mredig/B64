import Foundation

class ViewModel: ObservableObject {
	@Published
	var inputType: InputType = .text {
		didSet {
			updateOutput()
		}
	}

	@Published
	var mode: Mode = .encode {
		didSet {
			updateOutput()
		}
	}

	@Published
	var inputText = "" {
		didSet {
			updateOutput()
		}
	}

	@Published
	var inputData: Data? {
		didSet {
			updateOutput()
		}
	}

	@Published
	var output: Output?

	var decodeIgnoreUnknownCharacters: Bool {
		get { decodeOptions.contains(.ignoreUnknownCharacters) }
		set {
			if newValue {
				decodeOptions.insert(.ignoreUnknownCharacters)
			} else {
				decodeOptions.remove(.ignoreUnknownCharacters)
			}
		}
	}

	@Published
	var decodeOptions: Data.Base64DecodingOptions = [] {
		didSet {
			updateOutput()
		}
	}

	enum EncodeLineLength: String, CaseIterable {
		case length64 = "64 characters"
		case length76 = "76 characters"
		case noLimit = "No limit"
	}

	var encodeLineLength: EncodeLineLength {
		get {
			var out: EncodeLineLength
			if encodeOptions.contains(.lineLength64Characters) {
				out = .length64
			} else if encodeOptions.contains(.lineLength76Characters) {
				out = .length76
			} else {
				out = .noLimit
			}

			return out
		}

		set {
			encodeOptions.remove(.lineLength64Characters)
			encodeOptions.remove(.lineLength76Characters)

			switch newValue {
			case .noLimit:
				break
			case .length64:
				encodeOptions.insert(.lineLength64Characters)
			case .length76:
				encodeOptions.insert(.lineLength76Characters)
			}
		}
	}

	var encodeLineEndLineFeed: Bool {
		get { encodeOptions.contains(.endLineWithLineFeed) }
		set {
			if newValue {
				encodeOptions.insert(.endLineWithLineFeed)
			} else {
				encodeOptions.remove(.endLineWithLineFeed)
			}
		}
	}

	var encodeLineEndCarriageReturn: Bool {
		get { encodeOptions.contains(.endLineWithCarriageReturn) }
		set {
			if newValue {
				encodeOptions.insert(.endLineWithCarriageReturn)
			} else {
				encodeOptions.remove(.endLineWithCarriageReturn)
			}
		}
	}

	@Published
	var encodeOptions: Data.Base64EncodingOptions = [] {
		didSet {
			updateOutput()
		}
	}

	private func updateOutput() {
		switch mode {
		case .encode:
			output = updateEncodeOutput()
		case .decode:
			output = updateDecodeOutput()
		}
	}

	private func updateEncodeOutput() -> Output {
		switch inputType {
		case .file:
			// load data
			guard let inputData else { return .string(value: "Invalid data...") }
			let str = encode(input: inputData)
			return .string(value: str)
		case .text:
			let str = encode(input: inputText)
			return .string(value: str)
		}
	}

	private func updateDecodeOutput() -> Output {
		switch inputType {
		case .file:
			guard 
				let inputData,
				let unbasedData = Data(base64Encoded: inputData, options: decodeOptions)
			else { return .string(value: "Invalid data...") }
			return stringIfPossible(from: unbasedData)
		case .text:
			guard let unbasedData = Data(base64Encoded: inputText, options: decodeOptions) else {
				return .string(value: "Invalid string...")
			}
			return stringIfPossible(from: unbasedData)
		}
	}

	private func stringIfPossible(from data: Data) -> Output {
		if let str = String(data: data, encoding: .utf8) {
			return .string(value: str)
		} else {
			return .data(value: data)
		}
	}

	private func encode(input: String) -> String {
		encode(input: Data(input.utf8))
	}

	private func encode(input: Data) -> String {
		input.base64EncodedString(options: encodeOptions)
	}
}
