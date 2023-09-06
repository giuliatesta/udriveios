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
    
    func getTotalTime() -> Date {
        let elapsedTimes = coreDataManager.getAll(entityName: "ElapsedTime");
        var seconds = 0
        seconds = elapsedTimes.reduce(into: seconds) {sum, elapsedTime in
            sum += (elapsedTime.value(forKey: "seconds")) as? Int ?? 0;
        }
        return Date(timeIntervalSinceNow: TimeInterval(seconds))
    }
    
    func getBestScore() -> Int {
        let bestScore = coreDataManager.getAll(entityName: "BestScore").first  //It should be only one
        let totalSafeTime = (bestScore?.value(forKey: "totalSafeTime")) as? Int ?? 0
        let totalDangerousTime = (bestScore?.value(forKey: "totalDangerousTime")) as? Int ?? 0
        if(totalSafeTime + totalDangerousTime != 0) {
            return totalSafeTime / (totalSafeTime + totalDangerousTime);
        } else {
            return 0
        }
    }
    
    
    
}
