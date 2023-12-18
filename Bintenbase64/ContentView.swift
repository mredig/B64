import SwiftUI

struct ContentView: View {
	@StateObject
	private var vm = ViewModel()

    var body: some View {
        VStack {
			Picker(
				"Input Type",
				selection: $vm.inputType,
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
					selection: $vm.mode,
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
						vm.inputText = ""
						vm.inputData = nil
						vm.output = nil
					})
			}

			SectionTitleLabel(value: "Input")

			switch vm.inputType {
			case .file:
				fileInput
			case .text:
				textInput
			}

			if let output = vm.output {
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
    }

	@ViewBuilder
	private var textInput: some View {
		TextEditor(text: $vm.inputText)
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
