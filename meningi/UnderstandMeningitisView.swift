//
//  UnderstandMeningitisView.swift
//  meningi
//
//  Created by Alex Kolesnikov on 27/03/2026.
//

import SwiftUI

struct UnderstandMeningitisView: View {
    private let design = Design()

    private let videoURL = URL(string: "https://www.youtube.com/watch?v=IaQdv_dBDqM")!
    private let thumbnailURL = URL(string: "https://img.youtube.com/vi/IaQdv_dBDqM/hqdefault.jpg")!


    private var resources: [ResourceItem] {
        [
            ResourceItem(
                title: "NHS",
                subtitle: "Symptoms, emergency advice, next steps.",
                url: URL(string: "https://www.nhs.uk/conditions/meningitis/")!,
                icon: "cross.case.fill",
                accent: design.resourceBlue
            ),
            ResourceItem(
                title: "Meningitis Now",
                subtitle: "Support, recovery help, family guidance.",
                url: URL(string: "https://www.meningitisnow.org/")!,
                icon: "heart.text.square.fill",
                accent: design.resourceTeal
            ),
            ResourceItem(
                title: "Meningitis Research Foundation",
                subtitle: "Causes, vaccines, symptoms, awareness.",
                url: URL(string: "https://www.meningitis.org/")!,
                icon: "globe.europe.africa.fill",
                accent: design.resourceGreen
            ),
            ResourceItem(
                title: "NHS 111",
                subtitle: "Urgent advice when it is not 999.",
                url: URL(string: "https://111.nhs.uk/")!,
                icon: "phone.fill",
                accent: design.resourcePurple
            )
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                design.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBlock

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: design.sectionSpacing) {
                            introCard
                            watchSection
                            trustedResourcesSection
                        }
                        .padding(.horizontal, design.horizontalPadding)
                        .padding(.bottom, 32)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - UI

private extension UnderstandMeningitisView {

    var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Understand meningitis")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Watch first, then go deeper with trusted sources.")
                .font(.caption)
                .foregroundStyle(design.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, design.horizontalPadding)
        .padding(.top, 10)
        .padding(.bottom, 12)
    }

    var introCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This page is for proper understanding, not just quick scanning.")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)

            Text("Start with the video for the bigger picture, then use the links below for clearer medical guidance and more reliable detail.")
                .font(.subheadline)
                .foregroundStyle(design.secondaryText)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(design.cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }

    var watchSection: some View {
        let isSmallPhone = UIScreen.main.bounds.width <= 375

        return VStack(alignment: .leading, spacing: isSmallPhone ? 12 : 14) {
            sectionTitle(
                title: "Watch",
                icon: "play.rectangle.fill",
                accent: design.alertRed
            )

            Link(destination: videoURL) {
                videoCard
                    .padding(.bottom, UIScreen.main.bounds.width <= 375 ? 4 : 2)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, isSmallPhone ? 10 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(design.cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }
    
    var videoCard: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width
            let isSmallPhone = UIScreen.main.bounds.width <= 375
            let cardHeight = cardWidth * 9 / 16

            ZStack {
                AsyncImage(url: thumbnailURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: cardWidth, height: cardHeight * 4 / 3)
                            .clipped()
                            .frame(width: cardWidth, height: cardHeight)
                            .clipped()

                    case .failure(_), .empty:
                        LinearGradient(
                            colors: [
                                Color(red: 0.10, green: 0.15, blue: 0.24),
                                Color(red: 0.05, green: 0.09, blue: 0.16)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(width: cardWidth, height: cardHeight)

                    @unknown default:
                        Color.black
                            .frame(width: cardWidth, height: cardHeight)
                    }
                }

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.38),
                                Color(red: 0.03, green: 0.11, blue: 0.22).opacity(0.54),
                                Color.black.opacity(0.78)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: cardWidth, height: cardHeight)

                HStack {
                    Spacer()

                    HStack(spacing: 5) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 12, weight: .bold))

                        Text("YouTube")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color(red: 0.94, green: 0.28, blue: 0.30))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.black.opacity(0.18))
                    )
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
                }
                .padding(.top, isSmallPhone ? 12 : 16)
                .padding(.horizontal, 16)
                .frame(width: cardWidth, height: cardHeight, alignment: .topTrailing)

                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.32))
                        .frame(width: 70, height: 70)

                    Circle()
                        .stroke(.white.opacity(0.16), lineWidth: 1)
                        .frame(width: 70, height: 70)

                    Image(systemName: "play.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(x: 2)
                }
                .frame(width: cardWidth, height: cardHeight, alignment: .center)
                .offset(y: isSmallPhone ? 8 : 2)

                VStack(alignment: .leading, spacing: 2) {
                    Text("TED meningitis talk")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)

                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 11, weight: .bold))

                        Text("Tap to watch")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(design.alertRed)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, isSmallPhone ? 13 : 16)
                .frame(width: cardWidth, height: cardHeight, alignment: .bottomLeading)
            }
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.black.opacity(0.001))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(design.alertRed.opacity(0.18), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .aspectRatio(16 / 9, contentMode: .fit)
    }

    var trustedResourcesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle(
                title: "Trusted resources",
                icon: "link.circle.fill",
                accent: design.resourceAmber
            )

            VStack(spacing: 12) {
                ForEach(resources) { resource in
                    Link(destination: resource.url) {
                        resourceCard(resource)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(design.cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }

    func sectionTitle(title: String, icon: String, accent: Color) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(accent.opacity(0.16))
                    .frame(width: 38, height: 38)

                Image(systemName: icon)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(accent)
            }

            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
        }
    }

    func resourceCard(_ resource: ResourceItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(resource.accent.opacity(0.16))
                    .frame(width: 38, height: 38)

                Image(systemName: resource.icon)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(resource.accent)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(resource.title)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(resource.accent.opacity(0.9))
                }

                Text(resource.subtitle)
                    .font(.system(size: 13.5, weight: .medium))
                    .foregroundStyle(design.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(1.5)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.035))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Models

private struct ResourceItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let url: URL
    let icon: String
    let accent: Color
}

// MARK: - Design

private struct Design {
    let horizontalPadding: CGFloat = 16
    let sectionSpacing: CGFloat = 18

    let background = Color(red: 0.04, green: 0.07, blue: 0.11)
    let cardFill = Color(red: 0.09, green: 0.13, blue: 0.19)

    let alertRed = Color(red: 0.94, green: 0.28, blue: 0.30)
    let resourceTeal = Color(red: 0.20, green: 0.78, blue: 0.76)
    let resourceBlue = Color(red: 0.37, green: 0.62, blue: 0.98)
    let resourceGreen = Color(red: 0.35, green: 0.80, blue: 0.48)
    let resourcePurple = Color(red: 0.64, green: 0.49, blue: 0.95)
    let resourceAmber = Color(red: 1.00, green: 0.72, blue: 0.22)

    let bodyText = Color.white.opacity(0.88)
    let secondaryText = Color.white.opacity(0.68)
}

#Preview {
    UnderstandMeningitisView()
}
