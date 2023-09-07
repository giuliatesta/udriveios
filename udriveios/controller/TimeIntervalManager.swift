import Foundation

class TimeIntervalManager {
    var coreDataManager : CoreDataManager;

    private init() {
        coreDataManager = CoreDataManager.getInstance();
    }
    
    static private var instance : TimeIntervalManager = TimeIntervalManager();
    
    static func getInstance() -> TimeIntervalManager {
        return instance;
    }
    
    func saveTimeInterval(duration: Int, isDangerous: Bool) {
        coreDataManager.saveEntityElapsedTime(duration: duration, isDangerous: isDangerous)
    }
    
    func saveBestScore(){
        coreDataManager.saveEntityBestScore(totalSafeTime: Int(self.getTotalSafeElapsedTime()), totalDangerousTime: Int(self.getTotalDangerousElapsedTime()))
    }
    
    func getTotalTime() -> Double {
        let elapsedTimes = coreDataManager.getAll(entityName: "ElapsedTime");
        var seconds = 0
        seconds = elapsedTimes.reduce(into: seconds) {sum, elapsedTime in
            sum += (elapsedTime.value(forKey: "seconds")) as? Int ?? 0;
        }
        return Double(seconds)
    }
    
    func getBestScore() -> Double {
        let fetchedResults =  coreDataManager.getAll(entityName: "BestScore")
        if (!fetchedResults.isEmpty){
            let bestScore = fetchedResults.first //It should be only one
            let totalSafeTime = (bestScore?.value(forKey: "totalSafeTime")) as? Int ?? 0
            let totalDangerousTime = (bestScore?.value(forKey: "totalDangerousTime")) as? Int ?? 0
            if(totalSafeTime + totalDangerousTime != 0) {
                return 100.0 * (Double(totalSafeTime) / Double(totalSafeTime + totalDangerousTime));
            }else {
                return 0.0
            }
        }else {
            return 0.0
        }
    }
    
    func getCurrentScore() -> Double {
        let total = getTotalTime()
        print("Total time : \(total)")

        if ( total != 0.0){
            let tot = 100.0 * (self.getTotalSafeElapsedTime() / total)
            print("Current score : \(tot)")
            return tot
        }else{
            return 0
        }
        
    }
    
    func getTotalSafeElapsedTime() -> Double {
        var seconds = 0

        seconds = coreDataManager.getAll(entityName: "ElapsedTime").filter({ elapsedTime in
            elapsedTime.value(forKey: "isDangerous") as? Bool == false
        }).reduce(into: seconds) {sum, elapsedTime in
            sum += (elapsedTime.value(forKey: "seconds")) as? Int ?? 0;
        }
        print ("Safe Elapsed time: \(seconds)")
        return Double(seconds)
    }
    
    func getTotalDangerousElapsedTime() -> Double {
        var seconds = 0

        seconds = coreDataManager.getAll(entityName: "ElapsedTime").filter({ elapsedTime in
            elapsedTime.value(forKey: "isDangerous") as? Bool == true
        }).reduce(into: 0) {sum, elapsedTime in
            sum += (elapsedTime.value(forKey: "seconds")) as? Int ?? 0;
        }
        print ("Dangerous Elapsed time: \(seconds)")
        return Double(seconds)
    }
    
    func getFormattedTime(seconds: Int) -> Date {
        return Date (timeIntervalSinceNow: TimeInterval(seconds))
    }
}
