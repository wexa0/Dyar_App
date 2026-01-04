import SwiftUI

struct LanguageView: View {
    
    @ObservedObject var store: HomeStore
    let onBack: () -> Void
    
    
    @AppStorage("userPoints") var userPoints: Int = 0
    
    var body: some View {
        ZStack {
            Color(hex: "FFF9F3").ignoresSafeArea()
            
            Image("riyadhbackground")
                .resizable()
                .frame(width: 393, height: 941)
                .ignoresSafeArea()
                .opacity(0.8)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    headerView
                    
                    mainContentSection
                    
                    
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    // MARK: - Header
    private var headerView: some View {
        ZStack(alignment: .topLeading) {
            
            Image("background")
                .resizable()
                .scaledToFill()
            
                .frame(width: 400, height: 190)
                .clipped()
            
            HStack {
                HStack {
                    HStack(spacing: -6) {
                        Text("\(userPoints) نقاط")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image("points")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    .environment(\.layoutDirection, .leftToRight)
                    .padding(.horizontal, 2)
                    .padding(.vertical, -5)
                    .background(Color(hex: "6E7B6A").opacity(0.9))
                    .cornerRadius(7)
                }.padding(.vertical, 13)
                Spacer()
                
                Button {
                    UIApplication.shared.windows.first?.rootViewController =
                    UIHostingController(rootView: RiyadhDiscoveryView(onStart: {}, onBack: {}))
                    
                    
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.75))
                        .frame(width: 44, height: 44)
                } .padding(.horizontal, 0)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 60)
            .padding(.leading, 15)
            
            HStack(alignment: .center, spacing: 12) {
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("أهلًا بك في الرياض!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "6C3400"))
                    
                    Text("عاصمة المملكة ومهد الثقافة النجدية…")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "6C3400").opacity(0.85))
                }.padding(.top , 5)
                Spacer(minLength: 20)
                
                
            }
            .padding(.top, 110)
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 18)
        .padding(.top, 2)
    }
    
    // MARK: - Main Content
    private var mainContentSection: some View {
        VStack(spacing: 19) {
            
            VStack {
                Spacer()
                Text("اللهجة النجدية")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "6C3400"))
                    .padding(.top, -8)
            }
            .padding(.top, 20)
            .padding(.leading, -185)
            
            descriptiveBox
            
            VStack(spacing: 19) {
                infoCard(
                    title: "لهجة وسط نجد",
                    description: "لهجة الأكثر انتشاراً في الرياض والمناطق الزراعية المحيطة بها (وادي حنيفة)، وتُعتبر اللهجة الحضرية الحديثة فيها هي الأكثر شيوعاً اليوم.",
                    imageName: "wst",
                    titleStrokeColor: Color(hex: "FCE3CB")
                )
                
                infoCard(
                    title: "شمال نجد",
                    description: "تشمل لهجات حائل والقصيم (القصيمية والحتيمية)، وتتميز بخصائصها المميزة.",
                    imageName: "shm",
                    titleStrokeColor: Color(hex: "FCE3CB")
                )
            }
            .padding(.bottom, 36)
        }
    }
    
    // MARK: - Descriptive Box
    private var descriptiveBox: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("لهجة نجد هي مجموعة لهجات عربية نشأت في منطقة نجد بالمملكة العربية السعودية، وتتميز بالتنوع حسب المنطقة (شمال، وسط، جنوب، وبادية).")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "6C3400"))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 28)
                    .padding(.trailing, 3)
                    .padding(.vertical, 12)
                
                Spacer()
            }
            
            Image("lights")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 60)
                .offset(x: -10)
        }
        .frame(width: 370)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 1.0, green: 0.98, blue: 0.85))
        )
        .padding(.horizontal, 12)
    }
    
    // MARK: - Card
    private func infoCard(
        title: String,
        description: String,
        imageName: String,
        titleStrokeColor: Color? = nil
    ) -> some View {
        
        ZStack(alignment: .bottom) {
            ZStack(alignment: .topLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 370, height: 200)
                    .clipped()
                    .cornerRadius(20)
                
                outlinedTitle(title)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(Color(hex: "6C3400"))
                    .shadow(color: .white.opacity(0.9), radius: 2, x: 0, y: 0)
                
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(Color(hex: "6C3400"))
                    .padding(.top, 6)
                    .padding(.trailing, 8)
                    .padding(.leading, 10)
            }
            
            VStack {
                Spacer()
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "6C3400"))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 18)
                    .padding(.trailing, 20)
                    .padding(.vertical, 15)
                    .frame(width: 370, alignment: .leading)
                    .background(
                        Rectangle()
                            .fill(Color.white.opacity(0.9))
                    )
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(width: 360)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    @ViewBuilder
    func outlinedTitle(_ text: String) -> some View {
        ZStack {
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
                .offset(x: -0.8, y: 0)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
                .offset(x: 0.8, y: 0)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
                .offset(x: 0, y: -0.8)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
                .offset(x: 0, y: 0.8)
            
            Text(text)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(Color(hex: "6C3400"))
        }
        .foregroundColor(Color(hex: "6C3400"))
    }
    
    
}

#Preview("LanguageView") {
    NavigationStack {
        LanguageView(
            store: HomeStore(),
            onBack: {}
        )
    }
}
