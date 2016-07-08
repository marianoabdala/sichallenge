import Foundation
import UIKit

class PlayerViewModel {
    
    let id: Int
    let color: UIColor
    let name: String
    let number: String

    init(with model: PlayerModel, in team: TeamViewModel) {
        
        self.id = model.id
        self.color = team.color
        
        let firstName = model.firstName ?? "??"
        let lastName = model.lastName ?? "??"
        
        self.name = "\(firstName)\n\(lastName)"
        self.number = model.number ?? "??"
    }
}
