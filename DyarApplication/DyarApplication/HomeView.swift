import SwiftUI
import Combine

enum RegionID: String, CaseIterable, Hashable, Codable {
    case riyadh, alula, eastern
}

struct HomeState: Codable {
    
    var points: Int
    var completedRegions: Int
    var progress: [RegionID: Double]
    var isLocked: [RegionID: Bool]
    var requiredPointsToUnlock: [RegionID: Int]
}

final class HomeStore: ObservableObject {
    private let key = "home_state_v1"
    
    @Published var state: HomeState { didSet { save() } }
    
    init() {
        let defaultState = HomeState(
            points: 0,
            completedRegions: 0,
            progress: [.riyadh: 0.0, .alula: 0.0, .eastern: 0.0],
            isLocked: [.riyadh: false, .alula: true, .eastern: true],
            requiredPointsToUnlock: [.alula: 50, .eastern: 100]
        )
        
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(HomeState.self, from: data) {
            self.state = decoded
        } else {
            self.state = defaultState
        }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func tryUnlock(_ id: RegionID) {
        let req = state.requiredPointsToUnlock[id] ?? 0
        if state.points >= req {
            state.isLocked[id] = false
        } else {
            print("المنطقة بانتظارك... اجمع \(req) نقطة للفتح!")
        }
    }
}

struct HomeView: View {
    
    @State private var showUnlockAlert = false
    @State private var unlockAlertMessage = ""
    @AppStorage("riyadhQuizCompleted") var riyadhQuizCompleted: Bool = false
    @State private var path = NavigationPath()
    
    
    
    @StateObject private var store = HomeStore()
    
    private let totalRegions: Int = 3
    @AppStorage("userPoints") var userPoints: Int = 0
    
    var body: some View {
        let overall = Double(store.state.completedRegions) / Double(totalRegions)
        
        
        
        
        VStack(spacing: 18) {
            
            // 1) Header
            header.ignoresSafeArea()
            
            // 2) Progress card
            progressCard(overall: overallProgress)
            
            // 3) Title
            Text("المناطق")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color(hex: "6C3400"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 24)
                .padding(.top, 6)
                .padding(.bottom, 20)
            
            
            ScrollView(showsIndicators: false) {
                // 4) Regions
                regionCard(
                    id: .riyadh,
                    title: "الرياض",
                    imageName: "riyadh",
                    locked: store.state.isLocked[.riyadh] ?? false,
                    progress: store.state.progress[.riyadh] ?? 0,
                    
                    
                    unlockText: nil,
                    lockedBG: nil
                    
                    
                )
                
                regionCard(
                    id: .alula,
                    title: "العلا",
                    imageName: "alula",
                    locked: store.state.isLocked[.alula] ?? true,
                    progress: store.state.progress[.alula] ?? 0,
                    unlockText: unlockText(for: .alula),
                    lockedBG: "back2"
                )
                
                regionCard(
                    id: .eastern,
                    title: "المنطقة الشرقية",
                    imageName: "shargiya",
                    locked: store.state.isLocked[.eastern] ?? true,
                    progress: store.state.progress[.eastern] ?? 0,
                    unlockText: unlockText(for: .eastern),
                    lockedBG: "back2"
                )
                
                Spacer().frame(height: 20)
            }
            .padding(.top, -30)
        }
        .background(
            ZStack {
                Image("back2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .opacity(0.60)
                
            }
        )
        
        .environment(\.layoutDirection, .rightToLeft)
        .overlay {
            if showUnlockAlert {
                ZStack {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showUnlockAlert = false
                        }
                    
                    VStack(spacing: 16) {
                        Text("لا تملك نقاط كافية")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "6C3400"))
                            .multilineTextAlignment(.center)
                        
                        Text(unlockAlertMessage)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Button {
                            showUnlockAlert = false
                        } label: {
                            Text("أكمل")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color(hex: "6E7B6A"))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                }
                .transition(.opacity)
                .zIndex(999)
            }
        }
        
        
        
    }
    
    
    private var overallProgress: Double {
        let allRegions = RegionID.allCases
        let values = allRegions.map { store.state.progress[$0] ?? 0 }
        let avg = values.reduce(0, +) / Double(allRegions.count)
        return min(max(avg, 0), 1)
    }
    
    
    private func unlockText(for id: RegionID) -> String {
        let req = store.state.requiredPointsToUnlock[id] ?? 0
        return "المنطقة بانتظارك... اجمع \(req) نقطة للفتح!"
    }
    
    // MARK: - Header
    private var header: some View {
        
        ZStack(alignment: .top) {
            
            Image("theme3")
                .resizable()
                .scaledToFill()
                .frame(width: 43, height: 100)
                .padding(.top, 0)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .topTrailing)
            
            Image("theme2")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 150)
            
                .clipped()
            
            HStack {
                Image("theme")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 150)
                    .clipped()
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            
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
                .padding(.horizontal, 4)
                .padding(.vertical, -5)
                .background(Color(hex: "6E7B6A").opacity(0.9))
                .cornerRadius(7)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 45)
            .padding(.leading, 9)
            
            VStack(spacing: 10) {
                Spacer().frame(height: 60)
                
                Text("استكشف السعودية")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "6C3400"))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("ابدأ رحلتك في الثقافة السعودية")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "6C3400").opacity(0.85))
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 50)
        .padding(.top, 50)
        .padding(.bottom, -48)
        .padding(.horizontal, 18)
    }
    
    
    // MARK: - Progress Card
    private func progressCard(overall: Double) -> some View {
        
        
        HStack(spacing: 18) {
            
            VStack(alignment: .trailing, spacing: 6) {
                Text("تابع تقدمك")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                Text("\(store.state.completedRegions) من \(totalRegions) اكتملت!")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.40), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: overall)
                    .stroke(Color(hex: "39B54A"),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(overall * 100))%")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 92, height: 92)
        }
        .padding(18)
        
        .background(
            LinearGradient(
                colors: [Color(hex: "8B5E3C"), Color(hex: "C9A27D")],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.14), radius: 10, x: 0, y: 7)
        .padding(.horizontal, 32)
        .padding(.top, 28)
    }
    
    // MARK: - Region Card
    private func regionCard(
        id: RegionID,
        title: String,
        imageName: String,
        locked: Bool,
        progress: Double,
        unlockText: String?,
        lockedBG: String?
    ) -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 22)
            
                .fill(Color.white.opacity(0.25))
                .overlay(
                    HStack(spacing: 0) {
                        
                        ZStack {
                            LinearGradient(
                                colors: [Color(hex: "7B4F2E"), Color(hex: "D2B190")],
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                            
                            VStack(alignment: .trailing, spacing: 10) {
                                Text(title)
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.trailing)
                                    .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
                                
                                if !locked {
                                    HStack(spacing: 10) {
                                        Text("\(Int(progress * 100))%")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white.opacity(0.95))
                                        
                                        ZStack(alignment: .leading) {
                                            Capsule()
                                                .fill(Color.white.opacity(0.25))
                                                .frame(height: 8)
                                            
                                            Capsule()
                                                .fill(Color(hex: "39B54A"))
                                                .frame(width: CGFloat(progress) * 120, height: 8)
                                        }
                                        .frame(width: 120)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Capsule()
                                        .fill(Color.white.opacity(0.20))
                                        .frame(width: 140, height: 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.trailing, 18)
                            .padding(.leading, 15)
                            .padding(.top, 18)
                            .padding(.bottom, 18)
                        }
                        .frame(height: 150)
                        .frame(width: 210)
                        
                        Group {
                            if id == .riyadh {
                                Image("riyadh").resizable().scaledToFill()
                            } else if id == .alula {
                                Image("alula").resizable().scaledToFill()
                            } else if id == .eastern {
                                Image("shargiya").resizable().scaledToFill()
                            }
                        }
                        .frame(width: 160, height: 150)
                        .clipped()
                        .overlay(alignment: .topTrailing) {
                            if id == .riyadh {
                                Image("logoriyadh")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                            }
                            if id == .eastern {
                                Image("logoshirgiya")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                            }
                            if id == .alula {
                                Image("logoalula")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                            }
                        }
                        .overlay(
                            CurveMask()
                                .fill(Color(hex: "F5F1E8"))
                                .frame(width: 0, height: 160),
                            alignment: .leading
                        )
                    }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                )
                .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 6)
            
            if id == .riyadh && progress == 1.0 {
                VStack(alignment: .leading, spacing: 4) {
                    
                    if !riyadhQuizCompleted {
                        HStack(spacing: 4) {
                            
                            
                            
                            
                            Text(" الكويز بانتظارك!\n")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(hex: "FFF0BE")) .padding(.top, 13)
                            
                            
                        }
                    } else {
                        HStack(spacing: 6) {
                            Text(" اكتملت المنطقة بالكامل!")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(hex: "FFF0BE"))
                            
                            
                        }
                    }
                }
                .padding(.top, 37)
                .padding(.horizontal, -170)
            }
            
            
            if locked {
                ZStack {
                    
                    Image(lockedBG ?? "back2")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                    
                    Color.black.opacity(0.35)
                }
                .allowsHitTesting(false)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .zIndex(0).frame(width: 370, height: 150)
                
                VStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(unlockText ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 18)
                    
                    Button {
                        let req = store.state.requiredPointsToUnlock[id] ?? 0
                        if store.state.points >= req {
                            store.tryUnlock(id)
                        } else {
                            unlockAlertMessage = "تحتاج \(req) نقطة لفتح هذه المنطقة. نقاطك الحالية: \(userPoints)"
                            showUnlockAlert = true
                            
                        }
                    } label: {
                        Text("افتح")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 100, height: 30)
                            .background(Color(hex: "6E7B6A"))
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, 6)
                .zIndex(1)
            }
        }
        .frame(height: 150)
        .padding(.horizontal, 33)
        .overlay {
            if !locked {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if id == .riyadh {
                            UIApplication.shared.windows.first?.rootViewController =
                            UIHostingController(rootView: RiyadhDiscoveryView(onStart: {}, onBack: {}))
                        } else {
                            print("Open region:", id)
                        }
                    }
            }
        }
        
        
    }
}





// MARK: - Curve mask
private struct CurveMask: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.maxX - rect.width * 0.05, y: rect.minY + rect.height * 0.20)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.maxX - rect.width * 0.05, y: rect.minY + rect.height * 0.80)
        )
        p.closeSubpath()
        return p
    }
}


#Preview {
    HomeView()
}

