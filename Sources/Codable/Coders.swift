//
//  Coders.swift
//  VD
//
//  Created by Daniil on 11.08.2019.
//

import VDCodable

extension VD {
    
    public enum Encoders {
        public typealias Dictionary = DictionaryEncoder
        public typealias JSON = VDJSONEncoder
    }
    
    public enum Decoders {
        public typealias Dictionary = DictionaryDecoder
        public typealias JSON = VDJSONDecoder
    }
    
}
