import SwiftUI

enum AppScreen {
    case splash, start, home, riyadhhome
}

struct RootView: View {
    @State private var screen: AppScreen = .splash

    var body: some View {
        ZStack {
            switch screen {

            case .splash:
                SplashView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        screen = .start
                    }
                }
                .transition(.opacity)

            case .start:
                StartView(onStart: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        screen = .home
                    }
                })
                .transition(.opacity)

            case .home:
                HomeView(
                )
                .transition(.opacity)

            case .riyadhhome:
                RiyadhDiscoveryView(
                    onStart: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            screen = .home
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            screen = .home
                        }
                    }
                )
                .transition(.opacity)
            }
        }
    }
}
