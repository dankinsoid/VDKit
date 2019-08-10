import Foundation

public struct PlainCodingKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init(_ string: String) {
        stringValue = string
    }
    
    public init(_ key: CodingKey) {
        stringValue = key.stringValue
        intValue = key.intValue
    }
    
}

extension Result where Success == Void {
    
    public static var success: Result { return .success(()) }
    
}
