import SwiftUI

/// A content-free shell around the existing native ReflectiveCard renderer.
/// Surface, rim, highlights and shadows are borrowed from ReflectiveCard.swift.
public enum CardGeneralPalette: String, CaseIterable, Identifiable {
    case lightPearl, lightRose, lightRed, lightOrange, lightAmber, lightLime, lightGreen, lightTeal, lightCyan, lightBlue, lightIndigo, lightViolet, lightMagenta
    case darkGraphite, darkRose, darkRed, darkOrange, darkAmber, darkLime, darkGreen, darkTeal, darkCyan, darkBlue, darkIndigo, darkViolet, darkMagenta

    public var id: String { rawValue }
    public var isLight: Bool { rawValue.hasPrefix("light") }

    fileprivate var hue: Int {
        switch self {
        case .lightPearl: return 0
        case .lightRose, .darkRose: return 1
        case .lightRed, .darkRed: return 2
        case .lightOrange, .darkOrange: return 3
        case .lightAmber, .darkAmber: return 4
        case .lightLime, .darkLime: return 5
        case .lightGreen, .darkGreen: return 6
        case .lightTeal, .darkTeal: return 7
        case .lightCyan, .darkCyan: return 8
        case .lightBlue, .darkBlue: return 9
        case .lightIndigo, .darkIndigo: return 10
        case .lightViolet, .darkViolet: return 11
        case .lightMagenta, .darkMagenta: return 12
        case .darkGraphite: return 0
        }
    }

    fileprivate var tint: SIMD3<Float> {
        switch hue {
        case 1: SIMD3(1.0, 0.55, 0.69)
        case 2: SIMD3(1.0, 0.32, 0.34)
        case 3: SIMD3(1.0, 0.53, 0.22)
        case 4: SIMD3(1.0, 0.77, 0.28)
        case 5: SIMD3(0.76, 0.91, 0.35)
        case 6: SIMD3(0.34, 0.82, 0.51)
        case 7: SIMD3(0.24, 0.80, 0.68)
        case 8: SIMD3(0.27, 0.78, 0.95)
        case 9: SIMD3(0.38, 0.62, 1.0)
        case 10: SIMD3(0.43, 0.45, 0.96)
        case 11: SIMD3(0.67, 0.46, 0.98)
        case 12: SIMD3(0.94, 0.40, 0.83)
        default: SIMD3(1, 1, 1)
        }
    }

    fileprivate var theme: Float { isLight ? 1 : 0 }
    fileprivate var baseColor: Color {
        if isLight {
            switch hue {
            case 1: Color(red: 1.00, green: 0.91, blue: 0.94)
            case 2: Color(red: 1.00, green: 0.89, blue: 0.89)
            case 3: Color(red: 1.00, green: 0.92, blue: 0.86)
            case 4: Color(red: 1.00, green: 0.96, blue: 0.83)
            case 5: Color(red: 0.95, green: 0.98, blue: 0.84)
            case 6: Color(red: 0.87, green: 0.97, blue: 0.89)
            case 7: Color(red: 0.85, green: 0.97, blue: 0.93)
            case 8: Color(red: 0.85, green: 0.96, blue: 0.99)
            case 9: Color(red: 0.87, green: 0.92, blue: 1.00)
            case 10: Color(red: 0.89, green: 0.89, blue: 1.00)
            case 11: Color(red: 0.94, green: 0.88, blue: 1.00)
            case 12: Color(red: 1.00, green: 0.88, blue: 0.97)
            default: Color(red: 0.94, green: 0.94, blue: 0.96)
            }
        } else {
            switch hue {
            case 1: Color(red: 0.23, green: 0.08, blue: 0.14)
            case 2: Color(red: 0.25, green: 0.055, blue: 0.065)
            case 3: Color(red: 0.27, green: 0.12, blue: 0.045)
            case 4: Color(red: 0.25, green: 0.19, blue: 0.045)
            case 5: Color(red: 0.16, green: 0.22, blue: 0.055)
            case 6: Color(red: 0.045, green: 0.19, blue: 0.095)
            case 7: Color(red: 0.035, green: 0.20, blue: 0.17)
            case 8: Color(red: 0.035, green: 0.18, blue: 0.24)
            case 9: Color(red: 0.045, green: 0.10, blue: 0.25)
            case 10: Color(red: 0.085, green: 0.075, blue: 0.25)
            case 11: Color(red: 0.17, green: 0.065, blue: 0.25)
            case 12: Color(red: 0.25, green: 0.055, blue: 0.19)
            default: Color(red: 0.105, green: 0.105, blue: 0.125)
            }
        }
    }
    var swatchColor: Color { baseColor }
    fileprivate var rimColor: Color { isLight ? Color.black.opacity(0.08) : .white.opacity(0.07) }
    fileprivate var rimHighlight: Color { isLight ? .white.opacity(0.86) : .white.opacity(0.10) }
    fileprivate var primaryShadow: Color { .black.opacity(isLight ? 0.12 : 0.55) }
    fileprivate var secondaryShadow: Color { .black.opacity(isLight ? 0.08 : 0.3) }
}

public struct CardGeneral<S: Shape, Content: View>: View {
    private let shape: S
    private let palette: CardGeneralPalette
    private let content: Content
    @State private var touchPoint: CGPoint = .zero
    @State private var isTouching = false

    public init(shape: S, thickness: CGFloat = 6, palette: CardGeneralPalette = .lightPearl, @ViewBuilder content: () -> Content) {
        self.shape = shape
        self.palette = palette
        self.content = content()
    }

    public var body: some View {
        content
            .background {
                ZStack {
                    shape.fill(palette.baseColor)
                    ReflectiveMetalPlate(touchPoint: $touchPoint, isTouching: $isTouching, tint: palette.tint, theme: palette.theme)
                        .clipShape(shape)
                }
            }
            .overlay {
                ReflectiveCardBorder(radius: 24, rimColor: palette.rimColor, highlightColor: palette.rimHighlight)
                    .clipShape(shape)
                    .allowsHitTesting(false)
            }
            .shadow(color: palette.primaryShadow, radius: 22, x: 0, y: 22)
            .shadow(color: palette.secondaryShadow, radius: 8, x: 0, y: 6)
            .contentShape(shape)
            .highPriorityGesture(DragGesture(minimumDistance: 0).onChanged { value in
                touchPoint = value.location
                isTouching = true
            }.onEnded { _ in isTouching = false })
    }
}

public extension View {
    func cardGeneral<S: Shape>(shape: S, thickness: CGFloat = 6, palette: CardGeneralPalette = .lightPearl) -> some View {
        CardGeneral(shape: shape, thickness: thickness, palette: palette) { self }
    }
}
