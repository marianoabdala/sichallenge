import Foundation

struct ParamsFormatter {
    
    static func format(url: String, params: [String: String?]) -> String {
        
        var url = url
        var firstParamSet = false
        
        params.forEach { (key, value) in
        
            guard let value = value else {
                
                return
            }
            
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) {

                if firstParamSet {
                    
                    url += "&"
                    
                } else {
                    
                    url += "?"
                    firstParamSet = true
                }

                url += "\(key)=\(encodedValue)"
            }
        }
        
        return url
    }
}
