import SwiftUI

struct VerticalLabel<Subview: View>: View {
	let label: String

	let content: Subview

	private var font: Font = .title3

	init(label: String, @ViewBuilder content: () -> Subview) {
		self.label = label
		self.content = content()
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			SectionTitleLabel(value: label)
				.titleFont(font)

			content
		}
	}

	func titleFont(_ font: Font) -> some View {
		var new = self
		new.font = font
		return new
	}
}
