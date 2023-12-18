import SwiftUI

struct ContentView: View {
	@StateObject
	private var vm = ViewModel()

    var body: some View {
        VStack {
			inputSelection

			HStack {
				modeView

				resetButton
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
			} else {
				Spacer()
			}
        }
        .padding()
    }

	private var inputSelection: some View {
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
	}

	private var modeView: some View {
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
	}

	private var resetButton: some View {
		Button(
			"Reset",
			action: {
				vm.inputText = ""
				vm.inputData = nil
				vm.output = nil
			})
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
				openFile()
			})
	}

	private func textOutput(_ text: String) -> some View {
		TextEditor(text: .constant(text))
			.fontDesign(.monospaced)
	}

	private func dataOutput(_ data: Data) -> some View {
		Button(
			"Save Binary File...",
			action: {
				print("save file")
			})
	}

	private func openFile() {
		let open = NSOpenPanel()
		open.canChooseFiles = true
		open.canChooseDirectories = false

		let result = open.runModal()
		guard result == .OK else { return }

		guard let url = open.url else { return }
		do {
			vm.inputData = try Data(contentsOf: url)
		} catch {
			print("Error loading data: \(error)")
		}
	}
}

#Preview {
    ContentView()
}
