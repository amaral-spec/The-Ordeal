import SwiftUI
import Combine
import AVFoundation

// MARK: - MultiBarVisualizerView
struct MultiBarVisualizerView: View {
    let values: [Float]
    let barCount: Int
    
    var body: some View {
        GeometryReader { geo in
            let width = max(0, geo.size.width)
            let height = max(0, geo.size.height)

            let safeBarCount = max(1, barCount)
            let barSpacing: CGFloat = 1
            let totalSpacing = CGFloat(safeBarCount - 1) * barSpacing
            let barWidth = max(0, (width - totalSpacing) / CGFloat(safeBarCount))

            // Agrupa os valores para criar barras suavizadas
            let chunkSize = max(1, values.count / safeBarCount)
            let barValues: [Float] = (0..<safeBarCount).map { i in
                let start = i * chunkSize
                let end = min(start + chunkSize, values.count)
                guard start < end else { return 0 }
                let slice = values[start..<end]
                return slice.reduce(0, +) / Float(slice.count)
            }

            HStack(alignment: .center, spacing: barSpacing) {
                ForEach(0..<safeBarCount, id: \.self) { i in
                    let v = barValues[i]
                    let capped = max(0.07, min(CGFloat(v), 1))
                    let barHeight = capped * height
                    let yOffset = (height - barHeight) / 2

                    Rectangle()
                        .fill(Color.primary.opacity(0.85))
                        .frame(width: barWidth, height: barHeight)
                        .cornerRadius(barWidth / 2)
                        .offset(y: yOffset)
                }
            }
        }
    }
}


struct PlaybackWaveformView: View {
    var progress: Double
    var barCount: Int = 24

    @State private var baseHeights: [Float] = []

    var body: some View {
        if baseHeights.isEmpty {
            // gera apenas 1x
            DispatchQueue.main.async {
                baseHeights = (0..<barCount).map { _ in Float.random(in: 0.1...1.0) }
            }
        }

        let bars: [Float] = baseHeights.enumerated().map { (i, base) in
            let threshold = Double(i) / Double(barCount)
            return progress >= threshold ? base : base * 0.2
        }

        return MultiBarVisualizerView(values: bars, barCount: barCount)
            .frame(height: 40)
            .animation(.easeOut(duration: 0.2), value: progress)
    }
}
