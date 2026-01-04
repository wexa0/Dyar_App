import SwiftUI

struct RiyadhDiscoveryView: View {
    
    @StateObject private var store = HomeStore()
    
    let onStart: () -> Void
    let onBack: () -> Void
    
    @State private var goToBuildings = false
    @State private var goToFood = false
    @State private var goToClothes = false
    @State private var goToLanguage = false
    @State private var goToDance = false
    @State private var goToHabits = false
    @State private var goToQuiz = false
    @State private var showNoAttemptsDialog = false
    @State private var resetProgress = false
    @AppStorage("remainingAttempts") var remainingAttempts: Int = 3
    @AppStorage("userPoints") var userPoints: Int = 0
    @AppStorage("riyadhPerfectScore") var riyadhPerfectScore: Bool = false
    @State private var showPerfectDialog = false
    
    
    func resetAllCategories() {
        for i in categories.indices {
            categories[i].isCompleted = false
        }
        store.state.points = 0
        store.state.progress[.riyadh] = 0.0
        
        @AppStorage("riyadhProgress") var riyadhProgress: Double = 0.0
        riyadhProgress = 0.0
        
        UserDefaults.standard.set(0.0, forKey: "riyadhProgress")
        
    }
    @Environment(\.dismiss) var dismiss
    
    @State private var categories: [NajdCategory] = [
        NajdCategory(title: "الأكل النجدي", imageName: "food", key: "foodCompleted"),
        NajdCategory(title: "البيوت والمباني", imageName: "houses", key: "buildingsCompleted"),
        NajdCategory(title: "الملابس", imageName: "clothing", key: "clothesCompleted"),
        NajdCategory(title: "الرقص التقليدي", imageName: "dance", key: "danceCompleted"),
        NajdCategory(title: "اللهجة", imageName: "dialect", key: "dialectCompleted"),
        NajdCategory(title: "العادات الشعبية", imageName: "customs", key: "habitsCompleted")
    ]
    
    
    private var progress: Double {
        guard !categories.isEmpty else { return 0 }
        return Double(categories.filter { $0.isCompleted }.count) / Double(categories.count)
    }
    
    private var allCompleted: Bool {
        categories.allSatisfy { $0.isCompleted }
    }
    
    
    private func handleCategoryTap(_ category: NajdCategory) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        
        if categories[index].isCompleted == false {
            categories[index].isCompleted = true
            store.state.progress[.riyadh] = progress
            
            if allCompleted {
                store.state.completedRegions = max(store.state.completedRegions, 1)
            }
        }
        
        if category.title == "البيوت والمباني" {
            goToBuildings = true
        }
        if category.title == "الأكل النجدي" {
            goToFood = true
        }
        if category.title == "الملابس" {
            goToClothes = true
        }
        if category.title == "اللهجة" {
            goToLanguage = true
        }
        if category.title == "الرقص التقليدي" {
            goToDance = true
        }
        if category.title == "العادات الشعبية" {
            goToHabits = true
        }
        
        
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color(hex: "FFF9F3")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    headerView
                    
                    Text("كنوز نجد")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color(hex: "6C3400"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                        .padding(.bottom, -15)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                            spacing: 14
                        )
                        {
                            ForEach(categories) { category in
                                CategoryCardView(category: category, isClickable: true) {
                                    handleCategoryTap(category)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 26)
                        .padding(.bottom, 120)
                    }
                    .ignoresSafeArea(edges: .bottom) // خليه يتجاهل تحت فقط
                    .safeAreaInset(edge: .top) { EmptyView().frame(height: 0) } // يمنع الارتفاع خلف العنوان
                    
                    
                }
                
                
                VStack {
                    Spacer()
                    startButton
                }
                if showNoAttemptsDialog {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(LinearGradient(
                                colors: [Color(hex: "#E5E5E5"), Color(hex: "#FFF9F3")],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: 300, height: 230)
                            .shadow(color: .black.opacity(0.25), radius: 22, x: 0, y: 4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showNoAttemptsDialog = false
                            }
                        
                        VStack(spacing: 18) {
                            Text("انتهت محاولاتك!")
                                .font(.system(size: 22, weight: .heavy))
                                .foregroundColor(Color(hex: "#6C3400"))
                            
                            Text("لقد استهلكت جميع محاولاتك لهذا القسم.\nيمكنك إعادة المحاولة من البداية.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(.black.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 12)
                            
                            VStack(spacing: 12) {
                                Button {
                                    withAnimation {
                                        remainingAttempts = 3
                                        resetAllCategories()
                                        resetProgress = true
                                        showNoAttemptsDialog = false
                                    }
                                } label: {
                                    Text("إعادة القسم")
                                        .font(.system(size: 13, weight: .heavy))
                                        .foregroundStyle(Color(hex: "#6B3A18"))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 0)
                                        .frame(width: 259, height: 35).overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color(hex: "#6B3A18").opacity(0.4), lineWidth: 1.5))
                                }
                                
                                Button {
                                    withAnimation {
                                        showNoAttemptsDialog = false
                                    }
                                } label: {
                                    Text("إلغاء")
                                        .font(.system(size: 13, weight: .heavy))
                                        .foregroundStyle(Color(hex: "#686868"))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 0)
                                        .frame(width: 259, height: 35).overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color(hex: "#686868").opacity(0.4), lineWidth: 1.5))
                                }
                            }
                        }
                        
                    }
                    .transition(.scale)
                }
                if showPerfectDialog {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showPerfectDialog = false }
                        }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(LinearGradient(
                                colors: [Color(hex: "#E5E5E5"), Color(hex: "#FFF9F3")],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: 300, height: 200)
                            .shadow(color: .black.opacity(0.25), radius: 22, x: 0, y: 4)
                        
                        VStack(spacing: 18) {
                            Text(" أحسنت!")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(Color(hex: "#6B3A18"))
                            
                            Text("لقد أجبتِ على جميع الأسئلة بشكل صحيح\nولا حاجة لإعادة الاختبار.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(.black.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 12)
                            
                            Button {
                                withAnimation { showPerfectDialog = false }
                            } label: {
                                Text("فهمت")
                                    .font(.system(size: 13, weight: .heavy))
                                    .foregroundStyle(Color(hex: "#6B3A18"))
                                    .frame(width: 259, height: 35)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color(hex: "#6B3A18").opacity(0.4), lineWidth: 1.5)
                                    )
                            }
                        }
                    }
                    .transition(.scale)
                }
                
            }
            
            .environment(\.layoutDirection, .rightToLeft)
            
            
            .navigationDestination(isPresented: $goToBuildings) {
                RiyadhBuildingView(
                    store: store,
                    onBack: { goToBuildings = false }
                )
            }
            .navigationDestination(isPresented: $goToQuiz) {
                QuizStartView()
            }
            
            .navigationDestination(isPresented: $goToFood) {
                FoodView(
                    store: store,
                    onBack: { goToFood = false }
                )
            }
            .navigationDestination(isPresented: $goToClothes) {
                ClothesView(
                    store: store,
                    onBack: { goToClothes = false }
                )
            }
            .navigationDestination(isPresented: $goToLanguage) {
                LanguageView(
                    store: store,
                    onBack: { goToLanguage = false }
                )
            }
            .navigationDestination(isPresented: $goToDance) {
                DanceView(
                    store: store,
                    onBack: { goToLanguage = false }
                )
            }
            .navigationDestination(isPresented: $goToHabits) {
                HabitsView(
                    store: store,
                    onBack: { goToHabits = false }
                )
            }
            
            
            
        }
    }
}

// MARK: - Header
extension RiyadhDiscoveryView {
    
    var headerView: some View {
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
                    UIHostingController(rootView: HomeView())
                    
                    
                    
                    
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
                }.padding(.top , 25)
                
                
                Spacer(minLength: 20)
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.40), lineWidth: 8)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color(hex: "21CB30"),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(), value: progress)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black.opacity(0.75))
                }
                .frame(width: 58, height: 58)
            }
            .padding(.top, 90)
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 18)
        .padding(.top, -70)
    }
}


// MARK: - Start Button
extension RiyadhDiscoveryView {
    
    
    var startButton: some View {
        
        VStack {
            Text("إختبر معرفتك")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color(hex: "6C3400"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.top, 10)
            
            Button {
                if riyadhPerfectScore == true {
                    showPerfectDialog = true
                    return
                }
                
                if remainingAttempts > 0 {
                    goToQuiz = true
                } else {
                    showNoAttemptsDialog = true
                }
            }
            
            label: {
                HStack(spacing: 8) {
                    Text("ابدأ الاختبار")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.white)
                    
                    Text("( \(remainingAttempts) / 3 )")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .frame(width: 350, height: 50)
            .background(
                allCompleted
                ? Color("CardGreen")               // ✅ مفعل
                : Color.gray.opacity(0.4)          // ❌ معطّل
            )
            .cornerRadius(25)
            .shadow(radius: allCompleted ? 4 : 0)
            .disabled(!allCompleted)               // ⭐ هذا الأساس
            .padding(.bottom, 10)
            
            
            
            .onChange(of: resetProgress) { _ in
                if resetProgress {
                    resetAllCategories()
                    resetProgress = false
                }
            }
            
            .disabled(!allCompleted)
            
        } .padding(.bottom, -15).background(Color("BackgroundCream"))
            .zIndex(10)
        
    }
    
}

// MARK: - Category Card
struct CategoryCardView: View {
    
    let category: NajdCategory
    let isClickable: Bool
    let action: () -> Void
    
    var body: some View {
        Group {
            if isClickable {
                Button(action: action) { cardContent }
                    .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
        ZStack(alignment: .center) {
            Image(category.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "6A3300").opacity(0.65),
                    Color(hex: "FFAB5F").opacity(0.25)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            
            Text(category.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
            
            if category.isCompleted {
                
                Color.black.opacity(0.15)
                    .cornerRadius(18)
                Image("success")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(.bottom, 0)
            }
            
        }
        .frame(width: 180, height: 155)
        .cornerRadius(18)
        .clipped()
    }
    
}

struct NajdCategory: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    @AppStorage var isCompleted: Bool
    
    init(title: String, imageName: String, key: String) {
        self.title = title
        self.imageName = imageName
        self._isCompleted = AppStorage(wrappedValue: false, key)
    }
}




// Preview
#Preview {
    RiyadhDiscoveryView(
        onStart: {},
        onBack: {}
    )
}
