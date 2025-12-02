////
////  OnboardingCoordinatorView.swift
////  OsVigaristas
////
////  Created by Ludivik de Paula on 04/11/25.
////
//
//import SwiftUI 
//
//struct OnboardingCoordinatorView: View {
//    @EnvironmentObject var authService: AuthService
//    @State private var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
//    
//    init() {
//        print("Onboading")
//    }
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("Hello, World!")
//            
//            Text("Completed: \(hasCompletedOnboarding ? "true" : "false")")
//                .font(.subheadline)
//                .foregroundStyle(.secondary)
//            
//            Button {
//                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
//                authService.markOnboardingComplete()
//            } label: {
//                Text("Finished Onboarding")
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(Color(red: 0.65, green: 0.13, blue: 0.29))
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//        }
//        .padding()
//    }
//}
