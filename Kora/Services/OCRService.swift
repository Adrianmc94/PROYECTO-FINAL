import Foundation
import Vision
import UIKit

class OCRService {
    // Función principal: Recibe una imagen y devuelve el texto y el precio detectado
    func processImage(_ image: UIImage, completion: @escaping (String, Double?) -> Void) {
        // 1. Convertimos la imagen al formato que entiende el framework Vision
        guard let cgImage = image.cgImage else { return }
        
        // 2. Creamos el manejador de la petición de análisis
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // 3. Definimos la petición: "Queremos reconocer texto"
        let request = VNRecognizeTextRequest { request, error in
            // Obtenemos los resultados (las palabras detectadas)
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var fullText = ""
            var detectedAmount: Double?
            
            // 4. Recorremos lo que la IA ha "leído"
            for observation in observations {
                // Cogemos la opción con más probabilidad de acierto
                if let topCandidate = observation.topCandidates(1).first {
                    fullText += topCandidate.string + "\n"
                    
                    // 5. Si aún no hemos encontrado un precio, intentamos extraerlo de esta línea
                    if detectedAmount == nil {
                        detectedAmount = self.extractAmount(from: topCandidate.string)
                    }
                }
            }
            // 6. Devolvemos los resultados a la interfaz
            completion(fullText, detectedAmount)
        }
        
        // Configuramos para que sea lo más preciso posible
        request.recognitionLevel = .accurate
        
        // Lanzamos el proceso (dentro de un try porque puede fallar si la imagen está corrupta)
        try? requestHandler.perform([request])
    }
    
    // Función auxiliar: Usa "Expresiones Regulares" para buscar números con decimales
    private func extractAmount(from text: String) -> Double? {
        // Busca patrones como "12.99" o "5,50"
        let pattern = #"\d+[.,]\d{2}"#
        if let range = text.range(of: pattern, options: .regularExpression) {
            // Limpiamos el texto: cambiamos comas por puntos para que el sistema lo entienda como número
            let cleanText = text[range].replacingOccurrences(of: ",", with: ".")
            return Double(cleanText)
        }
        return nil
    }
}
