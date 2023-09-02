import Foundation
import CoreML

class Classifier {
    
    var danger: Bool
    let model : UdriveClassifier;
    
    init(danger: Bool = true) {
        self.danger = danger;
        do {
            //TODO check configuration and try?
            self.model = UdriveClassifier();
        } catch {
            fatalError("Failed to load Core ML model")
        }
        
    }
    
    // TODO change parameter values into (SensorValues, SensorValues)
    func classify(values: SensorValues, threshold: Double) -> Bool {
        danger = true;
        /*var input : UdriveClassifierInput = UdriveClassifierInput(conv1d_input: )
        guard let prediction = try? model.prediction(input: values) else {
            fatalError("Failed to make prediction")
        }
        print(prediction.output)
         */
        return danger;
    }
}
