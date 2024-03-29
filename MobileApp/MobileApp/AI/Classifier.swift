//
//  Classifier.swift
//  SeeFood
//
//  Created by Toby Pang on 18/12/2023.
//

import CoreML
import Vision
import CoreImage
struct Classifier {
    private(set) var results: String?
    mutating func detect(ciImage: CIImage) {
        guard let model = try? VNCoreMLModel(for: medication_detect_1(configuration: MLModelConfiguration()).model)
        else {
            return
        }
        let request = VNCoreMLRequest(model: model)
        //request.usesCPUOnly=true
        request.imageCropAndScaleOption = .scaleFill
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        if let firstResult = results.first {
            self.results = firstResult.identifier
        }
    }
}
