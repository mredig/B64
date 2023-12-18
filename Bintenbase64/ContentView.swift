import SwiftUI

struct ContentView: View {
	
	@State
	private var inputType: InputType = .text

	@State
	private var mode: Mode = .encode

	@State
	private var inputText = ""
	@State
	private var inputData: Data?

	@State
	private var output: Output?

    var body: some View {
        VStack {
			Picker(
				"Input Type",
				selection: $inputType,
				content: {
					ForEach(InputType.allCases, id: \.self) {
						Text($0.rawValue.localizedCapitalized)
							.tag($0)
					}
				})
			.pickerStyle(SegmentedPickerStyle())

			HStack {
				Picker(
					"Mode",
					selection: $mode,
					content: {
						ForEach(Mode.allCases, id: \.self) {
							Text($0.rawValue.localizedCapitalized)
								.tag($0)
						}
					})
				.pickerStyle(RadioGroupPickerStyle())

				Button(
					"Reset",
					action: {
						inputText = ""
						inputData = nil
						output = nil
					})
			}

			SectionTitleLabel(value: "Input")

			switch inputType {
			case .file:
				fileInput
			case .text:
				textInput
			}

			if let output {
				SectionTitleLabel(value: "Output")

				switch output {
				case .string(let value):
					textOutput(value)
				case .data(let value):
					dataOutput(value)
				}
			}
        }
        .padding()
		.onChange(of: inputText) { newValue in
			output = .string(value: newValue)
		}
    }

	@ViewBuilder
	private var textInput: some View {
		TextEditor(text: $inputText)
	}

	@ViewBuilder
	private var fileInput: some View {
		Button(
			"Choose File...",
			action: {
				print("select file")
			})
	}

	private func textOutput(_ text: String) -> some View {
		TextEditor(text: .constant(text))
	}

	private func dataOutput(_ data: Data) -> some View {
		Button(
			"Save Binary File...",
			action: {
				print("save file")
			})
	}
}

#Preview {
    ContentView()
}
