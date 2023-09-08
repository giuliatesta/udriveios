import SwiftUI

struct LoadingView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager // Mark 1

    @State private var firstAnimation = false  // Mark 2
    @State private var secondAnimation = false // Mark 2
    @State private var startFadeoutAnimation = false // Mark 2
    
    @State private var isRotating = 0.0
    @ViewBuilder
    private var image: some View {  // Mark 3
        Image("car-steering-wheel-svgrepo-com")
            .fitImageModifier()
            .padding([.horizontal], 70)
            .rotationEffect(firstAnimation ? Angle(degrees: 0): Angle(degrees: 720)) // Mark 4
            //.rotationEffect(.degrees(isRotating))
            .scaleEffect(secondAnimation ? 0 : 1) // Mark 4
            .offset(y: secondAnimation ? 400 : 0) // Mark 4
            //.rotationEffect(.degrees(isRotating))
        
            .onAppear() {
                withAnimation(.linear(duration: 1).speed(0.25).repeatForever(autoreverses: false)) {
                    isRotating = 360.0
                }
            }
            .invertColorModifier()
    }
    @ViewBuilder
    private var backgroundColor: some View {  // Mark 3
        Color.white
    }
    private let animationTimer = Timer // Mark 5
        .publish(every: 0.5, on: .current, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            backgroundColor
            image  // Mark 3
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(animationTimer) { timerValue in
            updateAnimation()  // Mark 5
        }.opacity(startFadeoutAnimation ? 0 : 1)
    }
    
    private func updateAnimation() { // Mark 5
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
            // use this case to finish any work needed
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
