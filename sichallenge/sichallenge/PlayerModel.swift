import Foundation

struct PlayerModel {
    
    let id: Int
    let firstName: String?
    let lastName: String?
    let number: String?
    
    init(with dictionary: [String: AnyObject]) {
        
        self.id = dictionary["Id"] as! Int
        
        if let personDictionary = dictionary["Person"] as? [String: AnyObject] {
            
            self.firstName = personDictionary["FirstName"] as? String
            self.lastName = personDictionary["LastName"] as? String
            self.number = dictionary["JerseyNumber"] as? String

        } else {
            
            self.firstName = nil
            self.lastName = nil
            self.number = nil
        }
    }
}
