import Foundation
import UIKit

struct TeamModel {
    
    let id: Int
    let name: String?
    let color: String?
    
    init(with dictionary: [String: AnyObject]) {
        
        self.id = dictionary["Id"] as! Int
        self.name = dictionary["Name"] as? String
        
        let settingsDictionary = dictionary["Settings"] as? [String: AnyObject]
        self.color = settingsDictionary?["HighlightColor"] as? String
    }
}
