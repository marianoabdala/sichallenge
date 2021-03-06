import Foundation
import UIKit

class TeamViewModel {
    
    var hasError = false
    var errorMessage: String? = nil

    var name: String = ""
    var color: UIColor = UIColor.lightGray
    var players = [PlayerViewModel]()
    
    private let client: Client
    private var teamModel: TeamModel?
    
    init(withClient client: Client) {
        
        self.client = client
    }
    
    func loadTeam(withCompletion completionHandler: @escaping () -> ()) {
        
        self.client.fetch(completionHandler: { [weak self] responseDictionary in
            
            guard let strongSelf = self else {
                
                return
            }
            
            strongSelf.teamModel = TeamModel(with: responseDictionary)
            strongSelf.name = strongSelf.teamModel?.name ?? "[Unknown]"
            
            if let color = strongSelf.teamModel?.color {
            
                strongSelf.color = strongSelf.hexStringToUIColor(hex: color)
            }
            
            if let playersDictionaries = responseDictionary["Players"] as? [[String: AnyObject]] {
            
                strongSelf.players = playersDictionaries.map { playerDictionary -> PlayerViewModel in
                    
                    let playerModel = PlayerModel(with: playerDictionary)
                    let playerViewModel = PlayerViewModel(with: playerModel, in: strongSelf)
                    
                    return playerViewModel
                }
            }
            
            DispatchQueue.main.async(execute: completionHandler)
        },
        errorHandler: { [weak self] message in
    
            guard let strongSelf = self else {
            
                return
            }
            
            strongSelf.hasError = true
            strongSelf.errorMessage = message
            
            DispatchQueue.main.async(execute: completionHandler)
        })
    }
    
    func recordSelected(_ player: PlayerViewModel, completionHandler:@escaping () -> ()) {
     
        guard let teamModel = self.teamModel else {
            
            self.hasError = true
            self.errorMessage = "Record selected with missing team model."
            
            completionHandler()
            return
        }
        
        self.client.postPlayerTapped(player.model, from: teamModel, completionHandler: {
            
            //All good.
        },
        errorHandler: { [weak self] message in
            
            self?.hasError = true
            self?.errorMessage = message
            
            DispatchQueue.main.async(execute: completionHandler)
        })
    }
}

private extension TeamViewModel {
    
    // "Borrowed" from: http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var rgbValue:UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
