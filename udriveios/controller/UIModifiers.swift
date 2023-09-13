import Foundation
import SwiftUI


struct InvertColorModifier : ViewModifier {
    @Environment (\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if(colorScheme == .dark){
            content.colorInvert()
        } else {
            content
        }
    }
    
}

struct TextModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct CustomButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(.borderedProminent)
            .padding()
            .background(.blue, in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous))
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .shadow(color: dropShadow,
                    radius: configuration.isPressed ? 7: 10,
                    x: configuration.isPressed ? -5: -10,
                    y: configuration.isPressed ? -5: -10)
            .shadow(color: dropLight,
                    radius: configuration.isPressed ? 7: 10,
                    x: configuration.isPressed ? 5: 10,
                    y: configuration.isPressed ? 5: 10)
    }
}

struct CustomButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: { print("Pressed") }) {
            Label("Premi qui", systemImage: "star")
        }
        .buttonStyle(CustomButtonStyle())
    }
}

extension Image {

    func fillImageModifier() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    func fitImageModifier() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
    }
}

extension View {
    func invertColorModifier() -> some View {
        modifier(InvertColorModifier())
        
    }
}

extension Text {
    func makeHeadline() -> some View {
        modifier(TextModifier())
    }
}

// Using system font "San Francisco"
let fontSystem = Font.system(size: 30.0)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
