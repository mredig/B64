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
		.string(value: "Not implemented")
	}

	private func encode(input: String) -> String {
		encode(input: Data(input.utf8))
	}

	private func encode(input: Data) -> String {
		input.base64EncodedString(options: .lineLength64Characters)
	}
}
