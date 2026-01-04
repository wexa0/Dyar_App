//
//  QuizQuestionView.swift
//  Created by Wiam Ahmed Baalahtar on 02/07/1447 AH.
//

import Foundation
import SwiftUI

enum QuestionType {
    case multipleChoice
    case trueFalse
    case fillBlank
}

struct QuizQuestion {
    let id: Int
    let section: String
    let question: String
    let options: [String]
    let correctIndex: Int
    let type: QuestionType
}

let quizQuestions: [QuizQuestion] = [
    
    QuizQuestion(
        id: 1,
        section: "الأكل",
        question: "ماهي الأكلة اللي يُفرد فيها العجين على الصاج ثم يُغمر بالمرق؟",
        options: ["القرصان", "الجريش", "الكبسة"],
        correctIndex: 0,
        type: .multipleChoice
    ),
    
    QuizQuestion(
        id: 2,
        section: "البيوت والمباني",
        question: "ما الذي يميز العمارة النجدية القديمة؟",
        options: [
            "استخدام الحجر فقط",
            "البناء بالطين مع الأبراج للتهوية",
            "الاعتماد على الزجاج بكثرة"
        ],
        correctIndex: 1,
        type: .multipleChoice
    ),
    
    QuizQuestion(
        id: 3,
        section: "الملابس",
        question: "صُممت الملابس النجدية قديمًا لتتناسب مع المناخ الصحراوي.",
        options: ["صح", "خطأ"],
        correctIndex: 0,
        type: .trueFalse
    ),
    
    QuizQuestion(
        id: 4,
        section: "الرقص التقليدي",
        question: "ما الذي تمثّله العرضة النجدية في الثقافة السعودية؟",
        options: [
            "رقصة احتفالية بدون معنى",
            "تجسيد القوة، الوحدة، والروح الوطنية",
            "رقصة فردية تعتمد على الارتجال"
        ],
        correctIndex: 1,
        type: .multipleChoice
    ),
    
    QuizQuestion(
        id: 5,
        section: "اللهجة",
        question: "لماذا تختلف اللهجات داخل منطقة نجد؟",
        options: [
            "بسبب تنوّع القبائل واتساع المنطقة",
            "لأنها لهجة واحدة لا تتغير",
            "لتأثرها الكامل باللهجات الأجنبية"
        ],
        correctIndex: 0,
        type: .multipleChoice
    ),
    
    QuizQuestion(
        id: 6,
        section: "الأدب والشعر",
        question: "تميز الأدب النجدي قديمًا بالحكمة والارتباط بالبيئة الصحراوية.",
        options: ["صح", "خطأ"],
        correctIndex: 0,
        type: .trueFalse
    )
]
struct QuizQuestionView: View {
    
    @State private var selectedIndex: Int? = nil
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var currentQuestionIndex = 0
    @State private var showExitDialog = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showFinalResult = false
    @State private var score = 0
    @State private var timeRemaining = 120
    @State private var showTimeUpDialog = false
    @State private var timer: Timer?
    @AppStorage("remainingAttempts") var remainingAttempts: Int = 3
    @AppStorage("userPoints") var userPoints: Int = 0
    
    @AppStorage("riyadhQuizCompleted") var riyadhQuizCompleted: Bool = false
    @AppStorage("riyadhPerfectScore") var riyadhPerfectScore: Bool = false
    
    
    
    
    
    
    var currentQuestion: QuizQuestion {
        quizQuestions[currentQuestionIndex]
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                showTimeUpDialog = true
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    var finalScore: Int {
        switch remainingAttempts {
        case 2: return Int(Double(score) * 1.0)       case 1: return Int(Double(score) * 0.5)
        case 0: return Int(Double(score) * 0.25)
        default: return score
        }
    }
    
    
    var body: some View {
        ZStack {
            
            Color("BackgroundCream")
                .ignoresSafeArea()
            
            Image("sadoBackground")
                .resizable()
                .frame(width: 48)
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    
                    
                    Button {
                        showExitDialog = true
                        stopTimer()
                    }
                    label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.75))
                            .frame(width: 44, height: 44)
                    }
                    
                    
                    
                    
                    
                    Spacer()
                    
                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                    
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.75))
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color("CardGreen"))
                    .frame(width: 331, height: 360)
                    .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 4)
                    .overlay(
                        VStack(spacing: 16) {
                            
                            Text("\(currentQuestionIndex + 1) / \(quizQuestions.count)")
                                .font(.system(size: 19, weight: .heavy))
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(.top, 20)
                            
                            
                            Text(currentQuestion.question)
                            
                                .font(.system(size: 17, weight: .heavy))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 18)
                                .padding(.bottom, 24)
                                .padding(.top, 16)
                            
                            
                            
                            ForEach(currentQuestion.options.indices, id: \.self) { index in
                                Button {
                                    withAnimation(nil) {
                                        selectedIndex = index
                                        isCorrect = index == currentQuestion.correctIndex
                                        showResult = true
                                        
                                        if isCorrect {
                                            score += 20
                                        }
                                    }
                                } label: {
                                    Text(currentQuestion.options[index])
                                        .font(.system(size: 15, weight: .heavy))
                                        .foregroundStyle(Color(hex: "#6B3A18"))
                                        .frame(width: 270, height: 43).overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color(hex: "#6B3A18").opacity(0.4), lineWidth: 1.5)
                                        )
                                    
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(LinearGradient(
                                                    colors: [
                                                        Color(hex: "#E5E5E5"),
                                                        Color(hex: "#FFF9F3")
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                ))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .stroke(
                                                            showResult
                                                            ? (index == currentQuestion.correctIndex
                                                               ? Color(hex: "#3BC85B")
                                                               : (selectedIndex != nil && index == selectedIndex
                                                                  ? Color(hex: "#E04A4A")
                                                                  : Color.clear))
                                                            : Color.clear,
                                                            lineWidth: 2
                                                        )
                                                    
                                                )
                                            
                                            
                                        )
                                }
                                .disabled(showResult)
                            }
                            
                            Spacer()
                        }
                    )
                
                
                if showResult{
                    
                    ZStack (alignment: .trailing){
                        Spacer()
                        
                        Text(isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundStyle(.white).padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 50)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(isCorrect ? Color(hex: "#3BC85B") : Color(hex: "#E04A4A"))
                            ).shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 4)
                        
                        Image(isCorrect ? "success" : "failed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 122, height: 42).padding(.trailing, -40).shadow(color: .black.opacity(0.19), radius: 9, x: 0, y: 3)
                    }
                    
                    .padding(.horizontal, 35)
                    .padding(.top, 12)
                    
                }
                
                if showResult {
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation(nil) {
                                if currentQuestionIndex < quizQuestions.count - 1 {
                                    currentQuestionIndex += 1
                                    selectedIndex = nil
                                    showResult = false
                                    isCorrect = false
                                } else {
                                    stopTimer()
                                    showFinalResult = true
                                }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Text(currentQuestionIndex < quizQuestions.count - 1 ? "السؤال التالي" : "عرض النتيجة")
                                    .font(.system(size: 15, weight: .heavy))
                                    .foregroundStyle(.white)
                                
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.25))
                                        .frame(width: 28, height: 28)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("CardGreen"))
                                    .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 4)
                            )
                        }
                        .padding(.horizontal, 34)
                        .padding(.top, 8)
                    }
                }
                
                
                Spacer()
            }
            
            if showExitDialog {
                
                
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showExitDialog = false
                            startTimer()
                        }
                    }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(
                            colors: [Color(hex: "#E5E5E5"), Color(hex: "#FFF9F3")],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 300, height: 270)
                        .shadow(color: .black.opacity(0.25), radius: 22, x: 0, y: 4)
                    
                    VStack(spacing: 14) {
                        
                        Text("هل أنت متأكد أنك تريد الخروج؟")
                            .font(.system(size: 17, weight: .heavy))
                            .foregroundStyle(Color(hex: "#6B3A18"))
                            .multilineTextAlignment(.center).padding(.top, 12)
                        
                        Text("إذا خرجت الآن، لن يتم حفظ نقاطك أو إجاباتك.\nوستحتاج لإعادة الاختبار من البداية.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.black.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 1).padding(.bottom, 20)
                        
                        
                        Button {
                            withAnimation {
                                showExitDialog = false
                                startTimer()
                            }
                        } label: {
                            Text("متابعة الاختبار")
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundStyle(Color(hex: "#6B3A18"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 0)
                                .frame(width: 259, height: 35).overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(hex: "#6B3A18").opacity(0.4), lineWidth: 1.5)
                                )
                            
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(LinearGradient(
                                            colors: [
                                                Color(hex: "#E5E5E5"),
                                                Color(hex: "#FFF9F3")
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ))
                                )
                        }
                        
                        Button {
                            userPoints += 0
                            UIApplication.shared.windows.first?.rootViewController =
                            UIHostingController(rootView: RiyadhDiscoveryView(onStart: {}, onBack: {}))
                        } label: {
                            Text("خروج")
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundStyle(Color(hex: "#E04A4A"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 9)
                                .frame(width: 259, height: 35).overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(hex: "#E04A4A").opacity(0.4), lineWidth: 1.5)
                                )
                            
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(LinearGradient(
                                            colors: [
                                                Color(hex: "#E5E5E5"),
                                                Color(hex: "#FFF9F3")
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ))
                                )                    }
                    }
                    .padding()
                }
                .transition(.scale)
            }
            
            if showTimeUpDialog {
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(
                            colors: [Color(hex: "#E5E5E5"), Color(hex: "#FFF9F3")],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 300, height: 260)
                        .shadow(color: .black.opacity(0.25), radius: 22, x: 0, y: 4)
                    
                    VStack(spacing: 16) {
                        
                        Image("timeUp")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                        
                        Text("انتهى الوقت")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(Color(hex: "#6C3400"))
                        
                        Text("انتهى وقت الاختبار، لم يتم حفظ إجاباتك.")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundColor(.black.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            
                            Button {
                                showTimeUpDialog = false
                                startTimer()
                            } label: {
                                Text("إعادة المحاولة")
                                    .font(.system(size: 13, weight: .heavy))
                                    .foregroundStyle(Color(hex: "#6B3A18"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 0)
                                    .frame(width: 259, height: 35).overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color(hex: "#6B3A18").opacity(0.4), lineWidth: 1.5)
                                    )
                                
                            }
                            
                            Button {
                                
                                userPoints += 0
                                UIApplication.shared.windows.first?.rootViewController =
                                UIHostingController(rootView: RiyadhDiscoveryView(onStart: {}, onBack: {}))
                            } label: {
                                Text("الخروج")
                                    .font(.system(size: 13, weight: .heavy))
                                    .foregroundStyle(Color(hex: "#E04A4A"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 0)
                                    .frame(width: 259, height: 35).overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color(hex: "#E04A4A").opacity(0.4), lineWidth: 1.5)
                                    )
                                
                            }
                        }
                        .padding(.horizontal, 20)
                        
                    }
                    .padding(.vertical, 24)
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.25), radius: 22, x: 0, y: 6)
                }
            }
            
            
            
            if showFinalResult {
                
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(
                            colors: [Color(hex: "#E5E5E5"), Color(hex: "#FFF9F3")],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 300, height: 360)
                    
                        .shadow(color: .black.opacity(0.95), radius: 22, x: 0, y: 4)
                    
                    VStack(spacing: 18) {
                        
                        Image("finalResult")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                        
                        Text("انتهى الاختبار")
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundStyle(Color(hex: "#6B3A18")) .shadow(color: .black.opacity(0.95), radius: 22, x: 0, y: 4)
                        
                        VStack(spacing: 8) {
                            Text("نتيجتك النهائية:")
                                .font(.system(size: 15, weight: .heavy))
                                .foregroundStyle(.gray)
                            
                            Text("إجابات صحيحة: \(score / 20) / \(quizQuestions.count)")
                                .font(.system(size: 15, weight: .heavy))
                            
                            Text("نقاط مكتسبة: + \(finalScore)")
                                .font(.system(size: 15, weight: .heavy))
                        }
                        
                        Button {
                            riyadhQuizCompleted = true
                            userPoints += finalScore
                            if (score / 20) == quizQuestions.count {
                                riyadhPerfectScore = true
                            }
                            
                            UIApplication.shared.windows.first?.rootViewController =
                            UIHostingController(rootView: HomeView())
                            
                            
                        } label: {
                            Text("العودة للصفحة الرئيسية")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundStyle(Color(hex: "#FFFFFF"))
                                .frame(width: 240, height: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(stops: [
                                                    .init(color: Color(hex: "#6C3400"), location: 0.0),
                                                    .init(color: Color(hex: "#EAC5A3"), location: 1.3)
                                                ]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                    
                                )
                        }
                        .padding(.top, 12)
                    }
                    .padding()
                }
                
            }
            
            
        }.navigationBarBackButtonHidden(true).onAppear {
            startTimer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true).environment(\.layoutDirection, .leftToRight)
        
        
        
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            stopTimer()
        }
        
    }
}

#Preview {
    QuizQuestionView()
}
