//
//  MakeChallengeCoordinator.swift
//  OsVigaristas
//
//  Created by Ludivik de Paula on 19/11/25.
//

import SwiftUI

struct TrainingCoordinatorView: View {
    enum Route: Hashable {
        case startTraining
        case stopwatch
        case takePhoto
        //case openCamera
    }
    //@EnvironmentObject private var detector: InstrumentDetectionViewModel
    @Environment(\.dismiss) private var dismiss
    //@State private var instrumentItem: UIImage? = nil
    @State private var path: [Route] = []
    

   // @StateObject private var trainingVM = TrainingViewModel()
    @StateObject private var rec = MiniRecorder()
    @StateObject private var player = MiniPlayer()
    
    @State private var currentRoute: Route = .startTraining

    var body: some View {
        NavigationStack(path: $path) {
            screen(for: .startTraining)
                .navigationDestination(for: Route.self) { route in
                    screen(for: route)
                }
        }
        //.environmentObject(trainingVM)
    }
    
    @ViewBuilder
    private func screen(for route: Route) -> some View {
        switch route {
        case .startTraining:
            StartTrainingView { next in
                path.append(next)
            }
            .navigationBarBackButtonHidden(true)
        case .stopwatch:
            StopwatchView { next in
                path.append(next)
            }
            .navigationBarBackButtonHidden(true)
            //.environmentObject(trainingVM)
            
        case .takePhoto:
            TakeThePhotoView {
                dismiss()
            }   // .environmentObject(detector) // << ADD THIS
            
        }
    }
}
