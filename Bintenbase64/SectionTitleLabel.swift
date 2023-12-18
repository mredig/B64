import SwiftUI

struct SectionTitleLabel: View {

	let value: String

	private var font: Font = .title2

	init(value: String) {
		self.value = value
	}

	var body: some View {
		VStack(spacing: 4) {
			HStack {
				Text(value)
					.font(font)

				Spacer()
			}

			Divider()
		}
		.padding(.top, 16)
	}

	func titleFont(_ font: Font) -> some View {
		var new = self
		new.font = font
		return new
	}
}
