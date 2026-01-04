//  SplashView.swift
import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void

    @State private var scale: CGFloat = 0.86
    @State private var opacity: CGFloat = 1.0

    
    private let logoSize: CGFloat = 450
    private let titleSize: CGFloat = 80
    private let logoTitleSpacing: CGFloat = -100
    var body: some View {
        ZStack {
            
            Color.diyarBeige.ignoresSafeArea()

            VStack(spacing: logoTitleSpacing) {
                Image("logodyar")
                // <-- make sure this matches Assets name
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize, height: logoSize)

                Text("ديار")
                    .font(.system(size: titleSize, weight: .bold))
                    .foregroundColor(Color(hex: "963202"))
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: -70) 
        }
        .onAppear {
            // 1) Pop
            withAnimation(.spring(response: 0.42, dampingFraction: 0.62)) {
                scale = 1.0
            }

            // 2) Hold then dissolve
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                withAnimation(.easeOut(duration: 0.55)) {
                    opacity = 0.0
                }
            }

            // 3) Switch screen after dissolve
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                onFinish()
            }
            
        }
    }
}
#Preview {
    SplashView {
        // empty for preview
    }
}

