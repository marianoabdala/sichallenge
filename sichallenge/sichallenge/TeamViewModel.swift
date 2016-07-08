import Foundation
import UIKit

class TeamViewModel {
    
    var hasError = false
    var errorMessage: String? = nil

    var name: String = ""
    var color: UIColor = UIColor.lightGray()
    var players = [PlayerViewModel]()
    
    private let client: Client
    
    init(withClient client: Client) {
        
        self.client = client
    }
    
    func loadTeam(withCompletion completionHandler:() -> ()) {
        
        self.client.fetch(completionHandler: { [weak self] responseDictionary in
            
            guard let strongSelf = self else {
                
                return
            }
            
            let teamModel = TeamModel(with: responseDictionary)
            
            strongSelf.name = teamModel.name ?? "[Unknown]"
            
            if let color = teamModel.color {
            
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
}

extension TeamViewModel {
    
    // "Borrowed" from: http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
    private func hexStringToUIColor (hex:String) -> UIColor {
        
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
