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
    let onNavigate: (TrainingCoordinatorView.Route) -> Void
    
    // MARK: - Dynamic Time Formatter (hours/minutes only if needed)
    var formattedTime: String {
        let totalSeconds = Int(time)
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            // H:MM:SS.CS (no leading zero on hours)
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else if minutes > 0 {
            // MM:SS.CS
            return String(format: "%2d:%02d", minutes, seconds)
        } else {
            // SS.CS
            return String(format: "%2d", seconds)
        }
    }
    
    var body: some View {
        VStack {
            //Titulo
            Text("Treino")
                .font(.system(size: 26, weight: .bold))
                .padding(.bottom, 30)
            
            Spacer()
            
            //Timer
            Text(formattedTime)
                .font(.system(size: 64, weight: .bold))
           
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
                        .foregroundColor(isRunning ? Color("AccentColor") : Color("AccentColor"))
                    Image(systemName: isRunning ? "pause" : "play")
                        .foregroundStyle(.white)
                }
            }
        
            
            
            
            
            Spacer()
            
            //Botao de tirar foto
            Button(action: {
                if(isRunning == false && time != 0){
                    onNavigate(.takePhoto)
                }
            }) {
                if(!isRunning && time != 0){
                    ZStack {
                        Rectangle()
                            .frame(width: 200, height: 50)
                            .cornerRadius(10)
                            .foregroundColor(Color("AccentColor"))
                        
                        Text("Verificar")
                            .fontWeight(.bold)
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                    }
                }else{
                    Rectangle()
                        .frame(width: 200, height: 50)
                        .opacity(0)
                }
            }
            .padding(.bottom, 20)
        }
        
        
        
        
    }
    
    // MARK: - Timer Functions
    
    func startTimer() {
        isRunning = true
        if(time == 0){ //Impede de reiniciar o timer quando pausa e continua
            startDate = Date()
        }
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.time = Date().timeIntervalSince(self.startDate!)
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
}

   

#Preview {
    StopwatchView(onNavigate: { _ in })
        .environmentObject(InstrumentDetectionViewModel())

}

