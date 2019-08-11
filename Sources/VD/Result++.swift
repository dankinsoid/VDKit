import Foundation

extension Result where Success == Void {
    
    public static var success: Result { return .success(()) }
    
}
