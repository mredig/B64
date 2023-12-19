import SwiftUI

struct ContentView: View {
	@StateObject
	private var vm = ViewModel()

    var body: some View {
        VStack {
			inputSelection

			VerticalLabel(label: "Options") {
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					modeView

					switch vm.mode {
					case .decode:
						decodeOptions
					case .encode:
						encodeOptions
					}

					resetButton
				}
			}
			.titleFont(.title2)

			SectionTitleLabel(value: "Input")
				.titleFont(.title2)

			switch vm.inputType {
			case .file:
				fileInput
			case .text:
				textInput
			}

			if let output = vm.output {
				SectionTitleLabel(value: "Output")
					.titleFont(.title2)

				switch output {
				case .string(let value):
					textOutputView(value)
				case .data(let value):
					dataOutputView(prompt: "Save Binary File...", value)
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
		VerticalLabel(label: "Mode") {
			Picker(
				"",
				selection: $vm.mode,
				content: {
					ForEach(Mode.allCases, id: \.self) {
						Text($0.rawValue.localizedCapitalized)
							.tag($0)
					}
				})
			.pickerStyle(RadioGroupPickerStyle())
		}
		.titleFont(.title3)
	}

	private var decodeOptions: some View {
		Toggle("Ignore Unknown Characters", isOn: $vm.decodeIgnoreUnknownCharacters)
	}

	@ViewBuilder
	private var encodeOptions: some View {
		VerticalLabel(label: "Line Length") {
			Picker(
				"",
				selection: $vm.encodeLineLength,
				content: {
					ForEach(ViewModel.EncodeLineLength.allCases, id: \.self) {
						Text($0.rawValue.localizedCapitalized)
							.tag($0)
					}
				})
			.pickerStyle(RadioGroupPickerStyle())
		}
		.titleFont(.title3)

		VerticalLabel(label: "Line Endings") {
			Toggle("Line Feed", isOn: $vm.encodeLineEndLineFeed)
			Toggle("Carriage Return", isOn: $vm.encodeLineEndCarriageReturn)
		}
		.titleFont(.title3)
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

	@ViewBuilder
	private func textOutputView(_ text: String) -> some View {
		TextEditor(text: .constant(text))
			.fontDesign(.monospaced)

		dataOutputView(prompt: "Save output...", Data(text.utf8))
	}

	private func dataOutputView(prompt: String, _ data: Data) -> some View {
		Button(
			prompt,
			action: {
				saveFile(data)
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

	private func saveFile(_ data: Data) {
		let save = NSSavePanel()

		let result = save.runModal()
		guard result == .OK else { return }
		guard let url = save.url else { return }
		do {
			try data.write(to: url)
		} catch {
			print("Error saving data: \(error)")
		}
	}
}

#Preview {
    ContentView()
}
