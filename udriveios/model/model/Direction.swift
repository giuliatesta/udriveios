import Foundation

//Enum class representing the car's directions
enum Direction {
    /*
     * BREAK: sudden break
     * ACCELERATION: sudden acceleration
     * LEFT: sudden left turn
     * RIGHT: sudden right turn
     * NONE:  no sudden movement is being performed
     */
    case BREAK, ACCELERATION, LEFT, RIGHT, NONE
    
    static func getDirection(label : Int64) -> Direction {
        switch label {
        case 0:
            return .ACCELERATION;
        case 1:
            return .RIGHT;
        case 2:
            return .LEFT;
        case 3:
            return .BREAK;
        case 4:
            return .NONE;
        default:
            fatalError("No direction available with \(label)");
        }
    }

    func getInt() -> Int {
        switch self {
        case .ACCELERATION:
            return 0;
        case .RIGHT:
            return 1;
        case .LEFT:
            return 2;
        case .BREAK:
            return 3;
        case .NONE:
            return 4;
        }
    }
    
    static func getName(direction : Int64) -> String {
        switch direction {
        case 0:
            return "Accelerazione";
        case 1:
            return "Curva a destra";
        case 2:
            return "Curva a sinistra";
        case 3:
            return "Frenata";
        case 4:
            return "Niente";
        default:
            fatalError("No direction available with \(direction)");
        }
    }
    
    static func isDangerous(label: Int64) -> Bool{
        return label != Direction.NONE.getInt();
    }
}
