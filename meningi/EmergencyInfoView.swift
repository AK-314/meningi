//
//  EmergencyInfoView.swift
//  meningi
//
//  Created by Alex Kolesnikov on 26/03/2026.
//

import SwiftUI
import UIKit

struct EmergencyInfoView: View {
    private let design = Design()

    var body: some View {
        NavigationStack {
            ZStack {
                design.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBlock

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: design.sectionSpacing) {
                            heroCard

                            infoCard(
                                title: "What to do right now",
                                icon: "bolt.fill",
                                accent: .red
                            ) {
                                bulletList([
                                    "Call 999 immediately",
                                    "Say you are worried about possible meningitis or sepsis",
                                    "Do not wait for a rash or for more symptoms",
                                    "If they are getting worse quickly, make that clear"
                                ])
                            }

                            infoCard(
                                title: "While waiting for help",
                                icon: "clock.badge.exclamationmark",
                                accent: .red
                            ) {
                                bulletList([
                                    "Stay with them and keep watching closely",
                                    "If they are unconscious but breathing, put them on their side",
                                    "If they stop breathing normally, start CPR if you can",
                                    "Do not give food or drink if they are very drowsy, confused, or fitting"
                                ])
                            }

                            infoCard(
                                title: "What to tell 999",
                                icon: "phone.fill",
                                accent: .red
                            ) {
                                bulletList([
                                    "What symptoms are happening right now",
                                    "Whether they are hard to wake, confused, fitting, or struggling to breathe",
                                    "Whether symptoms are worsening quickly",
                                    "Your exact location and callback number"
                                ])
                            }

                            callButton
                        }
                        .padding(.horizontal, design.horizontalPadding)
                        .padding(.bottom, 110)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - UI

private extension EmergencyInfoView {

    var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Emergency help")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Act fast. Do not wait.")
                .font(.caption)
                .foregroundStyle(design.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, design.horizontalPadding)
        .padding(.top, 10)
        .padding(.bottom, 12)
    }

    var heroCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.red.opacity(0.18))
                        .frame(width: 36, height: 36)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.red.opacity(0.95))
                }

                Text("Emergency")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
            }

            Text("If someone may have meningitis or sepsis and seems severely unwell, get urgent medical help now.")
                .font(.subheadline)
                .foregroundStyle(design.bodyText)

            Text("Do not wait for things to settle.")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.red.opacity(0.16),
                    Color.red.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.red.opacity(0.55), lineWidth: 1.3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    func infoCard<Content: View>(
        title: String,
        icon: String,
        accent: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(accent.opacity(0.16))
                        .frame(width: 34, height: 34)

                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(accent)
                }

                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
            }

            content()
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

    func bulletList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Color.red.opacity(0.9))
                        .frame(width: 6, height: 6)
                        .padding(.top, 7)

                    Text(item.capitalizedSentence)
                        .foregroundStyle(design.bodyText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.body)
            }
        }
    }

    var callButton: some View {
        Button(action: callEmergency) {
            HStack(spacing: 10) {
                Image(systemName: "phone.fill")
                Text("Call 999 now")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.red)
            )
        }
    }

    func callEmergency() {
        if let url = URL(string: "tel://999") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Design

private struct Design {
    let horizontalPadding: CGFloat = 16
    let sectionSpacing: CGFloat = 18

    let background = Color(red: 0.04, green: 0.07, blue: 0.11)
    let cardFill = Color(red: 0.09, green: 0.13, blue: 0.19)

    let bodyText = Color.white.opacity(0.92)
    let secondaryText = Color.white.opacity(0.68)
}

// MARK: - Helpers

private extension String {
    var capitalizedSentence: String {
        prefix(1).uppercased() + dropFirst()
    }
}

#Preview {
    EmergencyInfoView()
}
