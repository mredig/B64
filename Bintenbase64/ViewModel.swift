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
				let unbasedData = Data(base64Encoded: inputData)
			else { return .string(value: "Invalid data...") }
			return stringIfPossible(from: unbasedData)
		case .text:
			guard let unbasedData = Data(base64Encoded: inputText) else {
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
		input.base64EncodedString(options: .lineLength64Characters)
	}
}
