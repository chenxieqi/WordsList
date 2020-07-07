//
//  DocumentScanView.swift
//  LearnWords
//
//  Created by chen on 2020/07/05.
//  Copyright © 2020 chen. All rights reserved.
//

import SwiftUI
import VisionKit
import Vision

struct DocumentScanView: View {
    @State private var showingScanningView = false
    @EnvironmentObject var documentContent:DocumentContent
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    ZStack{
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.gray.opacity(0.2))
                        Text(documentContent.content)
                    }
                }.padding()
            
            Spacer()
            
            HStack{
                Spacer()
                
                Button(action: {
                    self.showingScanningView = true
                }){
                    Text("Start Scanning")
                }
                .padding()
                .foregroundColor(.white)
                .background(Capsule().fill(Color.gray))
                
                Spacer()
            }.padding()
        }
        .navigationBarTitle("Text Recognition")
            .sheet(isPresented: $showingScanningView){
                DocumentScanViewController().environmentObject(self.documentContent)
            }
        }
        
    }

}

struct DocumentScanView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentScanView()
    }
}

struct DocumentScanViewController:UIViewControllerRepresentable{
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    @EnvironmentObject var documentContent:DocumentContent
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage]{
        var extractedImages = [CGImage]()
        for index in 0..<scan.pageCount{
            let extractedImage = scan.imageOfPage(at: index)
            guard let cgImage = extractedImage.cgImage else{continue}
            
            extractedImages.append(cgImage)
        }
        
        return extractedImages
    }
    
    fileprivate func recognizeText(from images: [CGImage])->String{
        
        var entireRecognizedText = ""
        
        let recognizeTextRequest = VNRecognizeTextRequest{(request,error) in
            guard error == nil else {return}
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
            
            let maximumRecognitionCandidates = 1
            for obsevation in observations{
                guard let candidate = obsevation.topCandidates(maximumRecognitionCandidates).first else {continue}
                
                entireRecognizedText += candidate.string
                entireRecognizedText += "\n"
            }
        }
        
        recognizeTextRequest.recognitionLevel = .accurate
        recognizeTextRequest.usesLanguageCorrection = true
        
        for image in images{
            let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
            try? requestHandler.perform([recognizeTextRequest])
        }
        
        return entireRecognizedText
    }
    
    
    class Coordinator:NSObject,VNDocumentCameraViewControllerDelegate{
        var parent: DocumentScanViewController
        
        init(parent:DocumentScanViewController) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let extractedImages = parent.extractImages(from: scan)
            let processedText = parent.recognizeText(from: extractedImages)
            self.parent.documentContent.content = processedText
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    
        
    }
    
}
