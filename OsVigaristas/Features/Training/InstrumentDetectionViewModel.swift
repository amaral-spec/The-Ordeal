import SwiftUI
import Vision
import CoreML



class InstrumentDetectionViewModel: ObservableObject {
    
    // State properties for the viewmodel, storing the data that needs to be displayed in contentview
    // SelectedImage is optional because in the initial launch there is no image selected
    @Published var selectedImage: UIImage?
    // The string that will be updated in the UI whenever a new image is selected
    @Published var classificationLabel: String = "Tire uma foto do seu instrumento para validar seu treino!"
    
    // Holds the actual model
    // VNCoreMLModel is a Vision module. Vision is Apple's framework for computer vision tasks
    // Vision deals with cropping input images, input size, converting color formats, etc., and deals
    // with potential errors in this process. It is the recommended way of using CoreML for images
    private var model: VNCoreMLModel
    static let shared = InstrumentDetectionViewModel()
    
    init() {
        do {
            let coreMLModel = try InstrumentIdentifier(configuration: MLModelConfiguration()).model
            
            // Vision framework wraps raw model and stores it in 'model' property
            self.model = try VNCoreMLModel(for: coreMLModel)
            
        } catch {
            fatalError("Failed to load CoreML model: \(error)")
        }
    }
    
    // Function that is called whenever the user picks a new image
    // @MainActor is necessary because this updates the UI. It guarantees this link, making the function
    // work on the main thread
    @MainActor
    func detect(image: UIImage) {
        // Immediately updates the image being shown, so that the user knows everything is working properly
        self.selectedImage = image
        self.classificationLabel = "Classifying..."
        
        // The weak self block only runs after the model has finished processing on a background thread
        // The weak self itself is important because it prevents a retain cycle
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            
            // Safely unrwaps result, obtaining an array of VNClassificationObservation sorted by confidence
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self?.updateClassification("Could not classify image.", on: .main)
                return
            }
            
            let confidence = String(format: "%.1f", topResult.confidence * 100)
            let label = topResult.identifier
            
//            if topResult.confidence >= 0.5 && label == "not_instrument" {
//                self?.updateClassification("x.circle", on: .main)
//            } else if topResult.confidence >= 0.5 && label != "not_instrument" {
//                self?.updateClassification("checkmark.seal", on: .main)
//            } else if topResult.confidence < 0.5 {
//                self?.updateClassification("questionmark.circle", on: .main)
//            } else {
//                self?.updateClassification("x.circle.fill", on: .main)
//            }
            
            if topResult.confidence >= 0.5 && label == "not_instrument" {
                self?.updateClassification("Nenhum instrumento identificado, tire outra foto", on: .main)
            } else if topResult.confidence >= 0.5 && label != "not_instrument" {
                self?.updateClassification("Instrumento identificado!", on: .main)
            } else if topResult.confidence < 0.5 {
                self?.updateClassification("Could not detect", on: .main)
            } else {
                self?.updateClassification("Unknown error", on: .main)
            }
        }
        
        // Converts image to CIImage (Core Image), which works better than UIImage in the context of the Vision framework
        guard let ciImage = CIImage(image: image) else {
            self.classificationLabel = "Failed to convert image."
            return
        }
        
        // The Task makes the app run these functions on a background thread, preventing app freezes
        // The do-catch block actually runs the model, performing the request on ciImage
        Task.detached(priority: .userInitiated) {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([request])
            } catch {
                self.updateClassification("Failed to perform request: \(error.localizedDescription)", on: .main)
            }
        }
    }
    
    // Used for dispatching the UI update to the main thread
    private func updateClassification(_ text: String, on queue: DispatchQueue) {
        queue.async {
            self.classificationLabel = text
        }
    }
}

