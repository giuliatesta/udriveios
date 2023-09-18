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
        let window = slidingWindow.window //Filter.lowPass(input: slidingWindow.window)
        if(window.count == WINDOW_SIZE) {
            for (index, sensorValues) in window.enumerated() {
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
    
    // if the window doesn't have enough values, an empty array is returned
    var window : [SensorValues] {
        return _window.count == WINDOW_SIZE ? _window : [SensorValues]();
    }
    
    func add(newData : SensorValues) {
        if(_window.count >= WINDOW_SIZE) {
            _window.remove(at: 0)   // removes the first inserted
        }
        _window.append(newData);
    }
}

class Filter {
   
    // one-dimensional median filter
    static func median(input: [Double]) -> [Double] {
        let halfWindow = WINDOW_SIZE / 2
        var filtered = [Double]()
        for (i, _) in input.enumerated() {
            let lowerBound = max(0, i - halfWindow)
            let upperBound = min(WINDOW_SIZE - 1, i + halfWindow)
            var window = Array(input[lowerBound...upperBound])
            window.sort()
            filtered.append(window[halfWindow])
        }
        return filtered
    }
    
    // apply one-dimensional median filter to each column of the window
    static func median2D(input: [SensorValues]) -> [SensorValues] {
        if(input.isEmpty) {
            return []
        }
        
        // initialises an empty 14x6 matrix of zeros
        var filtered =  Array(repeating: Array(repeating: 0.0, count: 6), count: WINDOW_SIZE)
        
        for col in 0..<5 {
            let column = input.map { value in
                value[col] ?? 0.0       // should never be 0
            }
            let filteredColumn = median(input: column)
            // for each row adds the corresponding value from the filtered column
            for (i, val) in filteredColumn.enumerated() {
                filtered[i][col] = val
            }
        }
        return SensorValues.cast(input: filtered)
    }
    
    static func lowPass(input: [SensorValues], alpha: Double = 0.4, normalize: Bool = true) -> [SensorValues] {
        if(input.isEmpty) {
            return []
        }
        
        // initialises an empty 14x6 matrix of zeros
        var filtered =  Array(repeating: Array(repeating: 0.0, count: 6), count: WINDOW_SIZE)
        
        for col in 0..<5 {
            let column = input.map { value in
                value[col] ?? 0.0       // should never be 0
            }
            
            var initialVal = column[0]
            var filteredColumn = column.map { val in
                initialVal = alpha * val + (1.0 - alpha) * initialVal
                return initialVal
            }
            
            if(normalize) {
                filteredColumn = Normalization.zScore(input: filteredColumn)
            }
            // for each row adds the corresponding value from the filtered column
            for (i, val) in filteredColumn.enumerated() {
                filtered[i][col] = val
            }
        }
        return SensorValues.cast(input: filtered)
    }
}


class Normalization {
    static func zScore(input: [Double]) -> [Double] {
        let size = Double(input.count)
        let mean = input.reduce(0, +) / size
        let standardDeviation = sqrt(input.map { pow($0 - mean, 2) }.reduce(0, +) / size )
        
        return input.map { val in
            (val - mean) / standardDeviation
        }
    }

}

