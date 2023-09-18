import SwiftUI

struct LoadingView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    @State private var firstAnimation = false
    @State private var secondAnimation = false
    @State private var startFadeoutAnimation = false
    
    @State private var isRotating = 0.0
    @ViewBuilder
    private var image: some View {
        Image("car-steering-wheel-svgrepo-com")
            .fitImageModifier()
            .padding([.horizontal], 70)
            .rotationEffect(firstAnimation ? Angle(degrees: 0): Angle(degrees: 720))
            .scaleEffect(secondAnimation ? 0 : 1)
            .offset(y: secondAnimation ? 400 : 0)
        
            .onAppear() {
                withAnimation(.linear(duration: 1).speed(0.25).repeatForever(autoreverses: false)) {
                    isRotating = 360.0
                }
            }
            .invertColorModifier()
    }
    @ViewBuilder
    private var backgroundColor: some View {
        Color.white
            .invertColorModifier()
    }
    private let animationTimer = Timer
        .publish(every: 0.5, on: .current, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            backgroundColor
            image
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(animationTimer) { timerValue in
            updateAnimation()
        }.opacity(startFadeoutAnimation ? 0 : 1)
    }
    
    private func updateAnimation() {
        switch launchScreenState.state {
        case .firstStep:
            withAnimation(.easeInOut(duration: 1)) {
                firstAnimation.toggle()
            }
        case .secondStep:
            if secondAnimation == false {
                withAnimation(.linear) {
                    self.secondAnimation = true
                    startFadeoutAnimation = true
                }
            }
        case .finished:
            break
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .environmentObject(LaunchScreenStateManager())
    }
}
