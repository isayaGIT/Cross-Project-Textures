import SwiftUI

@main
struct GlazeStudioApp: App {
    var body: some Scene { WindowGroup { CardGeneralPlayground() } }
}

private struct CardGeneralPlayground: View {
    @State private var selectedPalette: CardGeneralPalette = .lightPearl
    @State private var darkCanvas = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)
    private var canvas: Color { darkCanvas ? Color(red: 0.12, green: 0.13, blue: 0.16) : Color(red: 0.91, green: 0.92, blue: 0.94) }
    private var lightPalettes: [CardGeneralPalette] { [.lightPearl, .lightRose, .lightRed, .lightOrange, .lightAmber, .lightLime, .lightGreen, .lightTeal, .lightCyan, .lightBlue, .lightIndigo, .lightViolet, .lightMagenta] }
    private var darkPalettes: [CardGeneralPalette] { [.darkGraphite, .darkRose, .darkRed, .darkOrange, .darkAmber, .darkLime, .darkGreen, .darkTeal, .darkCyan, .darkBlue, .darkIndigo, .darkViolet, .darkMagenta] }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Glaze Studio").font(.headline)
                Spacer()
                Toggle("深色背景", isOn: $darkCanvas).labelsHidden()
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("LIGHT").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                swatchGrid(lightPalettes)
                Text("DARK").font(.caption2.weight(.semibold)).foregroundStyle(.secondary).padding(.top, 4)
                swatchGrid(darkPalettes)
            }

            Spacer(minLength: 4)
            CardGeneral(shape: RoundedRectangle(cornerRadius: 28, style: .continuous), thickness: 6, palette: selectedPalette) {
                Color.clear.frame(maxWidth: .infinity).frame(height: 320)
            }
            .frame(maxWidth: 320)
            .padding(.horizontal, 28)
            Spacer(minLength: 4)
        }
        .padding(22)
        .background(canvas.ignoresSafeArea())
        .preferredColorScheme(darkCanvas ? .dark : .light)
    }

    private func swatchGrid(_ palettes: [CardGeneralPalette]) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(palettes) { palette in
                Button {
                    selectedPalette = palette
                } label: {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(palette.swatchColor)
                        .frame(height: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .strokeBorder(selectedPalette == palette ? Color.primary : Color.primary.opacity(0.12), lineWidth: selectedPalette == palette ? 2.5 : 0.75)
                        }
                        .overlay {
                            if selectedPalette == palette {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(palette.isLight ? Color.black.opacity(0.7) : Color.white)
                            }
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(palette.rawValue)
                .accessibilityAddTraits(selectedPalette == palette ? .isSelected : [])
            }
        }
    }
}
