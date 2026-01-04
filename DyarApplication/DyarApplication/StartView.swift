import SwiftUI

struct StartView: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            Color.diyarBeige.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 10)

                Image("logodyar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)

                Spacer().frame(height: 24)

                Text("اختر منطقة وابدأ التعلّم")
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundColor(Color(hex: "963202"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 200)

                Button(action: onStart) {
                    Text("ابدأ")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 240, height: 68)
                        .background(Color.diyarButton)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 8)
                }

                Spacer()
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
