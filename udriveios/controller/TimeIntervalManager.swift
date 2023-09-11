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
    
    func saveBestScore() {
        coreDataManager.saveEntityBestScore(totalSafeTime: Int(self.getTotalTime(dangerous: false)), totalDangerousTime: Int(self.getTotalTime(dangerous: false)))
    }

    
    func getBestScore() -> Double {
        let fetchedResults = coreDataManager.getAll(entityName: "BestScore")
        if (!fetchedResults.isEmpty) {
            let bestScore = fetchedResults.first //It should be only one
            let totalSafeTime = (bestScore?.value(forKey: "totalSafeTime")) as? Int ?? 0
            let totalDangerousTime = (bestScore?.value(forKey: "totalDangerousTime")) as? Int ?? 0
            if(totalSafeTime + totalDangerousTime != 0) {
                return 100.0 * (Double(totalSafeTime) / Double(totalSafeTime + totalDangerousTime));
            }
        }
        return 0.0
    }
    
    func getCurrentScore() -> Double {
        let total = getTotalTime()
        print("Total time : \(total)")
        
        if (total != 0) {
            let safeTime = self.getTotalTime(dangerous: false)
            let tot = 100.0 * (Double(safeTime) / Double(total))
            print("Current score : \(tot)")
            return tot
        }
        return 0.0
    }
    
    func getTotalTime(dangerous: Bool? = nil) -> Int {
        var managedObject = coreDataManager.getAll(entityName: "ElapsedTime")
        if(dangerous != nil) {
            managedObject = managedObject.filter({ elapsedTime in
                elapsedTime.value(forKey: "isDangerous") as? Bool == dangerous})
        }
        let seconds = managedObject.reduce(into: 0) {sum, elapsedTime in
            sum += (elapsedTime.value(forKey: "seconds")) as? Int ?? 0;
        }
        return seconds
    }
}
