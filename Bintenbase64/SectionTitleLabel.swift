import SwiftUI

struct SectionTitleLabel: View {

	let value: String

	var body: some View {
		VStack(spacing: 4) {
			HStack {
				Text(value)
					.font(.title3)

				Spacer()
			}

			Divider()
		}
		.padding(.top, 16)
	}
}
