import SwiftUI

struct MoreView: View {
    private let design = Design()

    var body: some View {
        NavigationStack {
            ZStack {
                design.background
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    headerBlock

                    VStack(spacing: 12) {
                        moreRow("Vaccinations", systemImage: "syringe")
                        moreRow("My story", systemImage: "person.text.rectangle")
                        moreRow("About", systemImage: "info.circle")
                    }

                    Spacer()
                }
                .padding(.horizontal, design.horizontalPadding)
                .padding(.top, 10)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("More")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)
    }

    private func moreRow(_ title: String, systemImage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(design.secondaryText)
                .frame(width: 22)

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(0.32))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(design.cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct Design {
    let horizontalPadding: CGFloat = 16

    let background = Color(red: 0.04, green: 0.07, blue: 0.11)
    let cardFill = Color(red: 0.09, green: 0.13, blue: 0.19)
    let secondaryText = Color.white.opacity(0.68)
}

#Preview {
    MoreView()
}
