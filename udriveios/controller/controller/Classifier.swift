import Foundation
import CoreML

let WINDOW_SIZE : Int = 14;

/* Class used as a wrapper between the UdriveClassifier component and the Home view.
   Inputs are stored using a sliding window technique of size 14 and later classified */
class Classifier {
    let model : UdriveClassifer;
    var slidingWindow : SlidingWindow = SlidingWindow();
    
    init() {
        do {
            //TODO check configuration and try?
            self.model = try UdriveClassifer(configuration: MLModelConfiguration());
        } catch {
            fatalError("Failed to load Core ML model")
        }
    }
    
    func insert(sensorValues : SensorValues) {
        slidingWindow.add(newData: sensorValues)
    }
    
    private func createInput() -> MLMultiArray? {
        let multiArray = try! MLMultiArray(shape: [NSNumber(1), NSNumber(value: WINDOW_SIZE), NSNumber(6)], dataType: .double)
        if(slidingWindow.window.count == WINDOW_SIZE) {
            for (index, sensorValues) in slidingWindow.window.enumerated() {
                multiArray[index * 6 + 0] = NSNumber(value: sensorValues.gyroscopeX)
                multiArray[index * 6 + 1] = NSNumber(value: sensorValues.gyroscopeY)
                multiArray[index * 6 + 2] = NSNumber(value: sensorValues.gyroscopeZ)
                multiArray[index * 6 + 3] = NSNumber(value: sensorValues.accelerometerX)
                multiArray[index * 6 + 4] = NSNumber(value: sensorValues.accelerometerY)
                multiArray[index * 6 + 5] = NSNumber(value: sensorValues.accelerometerZ)
            }
            return multiArray
        } else {
            return nil;
        }
    }
    
    func classify() -> Int64 {
        let multiArray : MLMultiArray? = createInput();
        if(multiArray != nil) {
        let input : UdriveClassiferInput = UdriveClassiferInput(conv1d_input: multiArray!);
            guard let prediction = try? model.prediction(input: input) else {
                fatalError("Failed to make prediction")
            }
            print(prediction.classLabel)
            return prediction.classLabel;
        } else {
            return Int64(Direction.NONE.getInt());
        }
    }
   

}

class SlidingWindow {
    private var _window: [SensorValues] = [];
    
    //If the window doesn't have enough values, an empty array is returned
    var window : [SensorValues] {
        if(_window.count == WINDOW_SIZE) {
            return _window;
        } else {
            return [];
        }
    }

    
    func add(newData : SensorValues) {
        if(_window.count >= WINDOW_SIZE) {
            _window.remove(at: 0)   // removes the first inserted
        }
        _window.append(newData);
    }
    
}
