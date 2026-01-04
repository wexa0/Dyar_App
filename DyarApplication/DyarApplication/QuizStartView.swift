//
//  QuizStartView.swift
//  Created by Wiam Ahmed Baalahtar on 02/07/1447 AH.
//

import Foundation
import SwiftUI



struct QuizStartView: View {
    @AppStorage("remainingAttempts") var remainingAttempts: Int = 3
    @State private var showAttemptsHint = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundCream")
                    .ignoresSafeArea()
                
                Image("sadoBackground")
                    .resizable()
                    .frame(width: 48)
                    .ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color("CardGreen"))
                    .frame(width: 331, height: 314)
                    .shadow(color: Color.black.opacity(0.18),
                            radius: 4,
                            x: 0,
                            y: 4)
                    .overlay(
                        VStack(spacing: 0) {
                            Text("اختبر معرفتك في تراث نجد")
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundStyle(Color(hex: "#E5DFCB"))
                                .multilineTextAlignment(.center)
                                .padding(.top, 37).shadow(
                                    color: Color.black.opacity(0.25),
                                    radius: 0,
                                    x: 0,
                                    y: 3
                                )
                            
                            
                            Text("أجب عن الأسئلة خلال الوقت المحدد،\nواختبر صحة معلوماتك.")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 292)
                                .lineSpacing(6)
                                .padding(.bottom, 0).padding(.top, 20)     .shadow(
                                    color: Color.black.opacity(0.15),
                                    radius: 0,
                                    x: 0,
                                    y: 2
                                )
                            
                            
                            NavigationLink {
                                QuizQuestionView()
                                
                                    .onAppear {
                                        remainingAttempts -= 1
                                    }
                            }label: {
                                Text("ابدأ")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundStyle(Color(hex: "#6B3A18"))
                                    .frame(width: 269, height: 49)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(hex: "#E5E5E5"),
                                                        Color(hex: "#FFF9F3")
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )                                               .shadow(
                                                color: Color.black.opacity(0.2),
                                                radius: 6,
                                                x: 0,
                                                y: 4
                                            )
                                    )
                                
                            }
                            .padding(.bottom, 30) .padding(.top, 40)
                        }
                        
                    )
                
                
                
                
                VStack {
                    HStack {
                        
                        Button {
                            UIApplication.shared.windows.first?.rootViewController =
                            UIHostingController(rootView: RiyadhDiscoveryView(onStart: {}, onBack: {}))
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.75))
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: -20){
                            
                            Button {
                                showAttemptsHint = true
                            } label: {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.black.opacity(0.75))
                                    .frame(width: 44, height: 44)
                            }
                            .popover(isPresented: $showAttemptsHint, arrowEdge: .top) {
                                VStack( alignment: .trailing,spacing: 12) {
                                    Text("نظام المحاولات والنقاط")
                                        .multilineTextAlignment(.trailing)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(Color(hex: "#6C3400")).padding(.horizontal , 8).padding(.top , 8)
                                    
                                    Text("""
                        لديك 3 محاولات، وكلما قلّت 
                        المحاولات قلت النقاط:
                        
                        • الأولى: 100٪ من النقاط  
                        • الثانية: 50٪  
                        • الثالثة: 25٪  
                        
                        """)
                                    
                                    .foregroundColor(Color(hex: "#686868")).padding(.horizontal , 2)
                                    .font(.system(size: 13, weight: .semibold))
                                    
                                    .multilineTextAlignment(.trailing)
                                    
                                    
                                    
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                                .padding()
                                .presentationCompactAdaptation(.popover)
                            }
                            
                            Text("لديك \(remainingAttempts)/3 محاولة")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color(hex: "#6C3400"))
                                .frame(width: 140, height: 40)
                            
                        }
                        
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#E5E5E5"),
                                            Color(hex: "#FFF9F3")
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )                                               .shadow(
                                    color: Color.black.opacity(0.2),
                                    radius: 6,
                                    x: 0,
                                    y: 4
                                )
                        )
                        
                        
                        Spacer()
                        
                        
                        Text("2:00")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.75))
                            .frame(width: 60, height: 44, alignment: .trailing)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                    
                    Spacer()
                }
                
            }
        }.environment(\.layoutDirection, .leftToRight)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
    }
}




#Preview {
    QuizStartView()
}
