import SwiftUI
import PhotosUI

struct StopwatchView: View {
    
    @EnvironmentObject var detector: InstrumentDetectionViewModel
    
    
    @State private var instrumentItem: UIImage? = nil
    @State private var showPicker = false
    
    @State private var time: Double = 0.00
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    @State private var startDate: Date?
    @State private var oldTime = 0.00
    
    let onNavigate: (TrainingCoordinatorView.Route) -> Void
    
    // MARK: - Dynamic Time Formatter (hours/minutes only if needed)
    var formattedTime: String {
        let totalSeconds = Int(time)
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else if minutes > 0 {
            // MM:SS.CS
            return String(format: "%2d:%02d", minutes, seconds)
        } else {
            // SS.CS
            return String(format: "%02d", seconds)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            
            Spacer()
            
            //Timer
            
            Text(formattedTime)
                .font(.system(size: 64, weight: .bold))
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            
            
            Spacer()
            
            
            Button {
                if isRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(isRunning ? Color("RedCard") : Color("RedCard"))
                    Image(systemName: isRunning ? "pause" : "play")
                        .foregroundStyle(.white)
                }
            }
        }
        
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text("Treino")
                    .font(.headline)
            }
            
            ToolbarItem(placement: .automatic) {
                Button {
                    onNavigate(.takePhoto)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .disabled(isRunning || time == 0)
                .buttonStyle(.borderedProminent)
                .tint(Color("RedCard"))
            }
        }
        
    }
    
    // MARK: - Timer Functions
    
    func startTimer() {
        isRunning = true
        startDate = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.time = Date().timeIntervalSince(self.startDate!) + oldTime
        }
    }
    
    func stopTimer() {
        isRunning = false
        oldTime = time
        timer?.invalidate()
        timer = nil
        
    }
}



#Preview {
    StopwatchView(onNavigate: { _ in })
        .environmentObject(InstrumentDetectionViewModel())
    
}

