import SwiftUI

// MARK: - Hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }

    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

// MARK: - Paleta de colores
extension Color {
    static let brandBackground = Color(
        light: Color(hex: "F5F0E8"),
        dark:  Color(hex: "1C1410")
    )
    static let brandSurface = Color(
        light: Color(hex: "FFFFFF"),
        dark:  Color(hex: "251D18")
    )
    static let brandSurfaceAlt = Color(
        light: Color(hex: "EDE8DF"),
        dark:  Color(hex: "2E2420")
    )
    static let brandWood = Color(
        light: Color(hex: "7B4F2E"),
        dark:  Color(hex: "A0693F")
    )
    static let brandWoodLight = Color(
        light: Color(hex: "A0693F"),
        dark:  Color(hex: "C4855A")
    )
    static let brandWine = Color(
        light: Color(hex: "7A2E3C"),
        dark:  Color(hex: "9A4455")
    )
    static let brandTextPrimary = Color(
        light: Color(hex: "1C1410"),
        dark:  Color(hex: "F5F0E8")
    )
    static let brandTextSecondary = Color(
        light: Color(hex: "6B5B4E"),
        dark:  Color(hex: "B8A898")
    )
    static let brandTextTertiary = Color(
        light: Color(hex: "A89880"),
        dark:  Color(hex: "6B5B4E")
    )
}

// MARK: - Tipografía
struct BrandFont {
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .custom("Didot", size: size).weight(weight)
    }
    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Futura-Medium", size: size).weight(weight)
    }
}

// MARK: - Card modifier
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.brandSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.brandTextPrimary.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Botón primario
struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BrandFont.sans(15, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isEnabled ? Color.brandWood : Color.brandTextTertiary)
            .foregroundStyle(Color.brandBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
