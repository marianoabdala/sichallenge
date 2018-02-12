import Foundation

class SIClient: Client {
    
    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

    /**
     Fetches a team and its players from SI.
     
     - parameter completionHandler: Called when completed successfully. Returns dictionary.
     - parameter errorHandler:      Returns error message.
     */
    func fetch(completionHandler: @escaping ([String : AnyObject]) -> (), errorHandler: @escaping (_ message: String) -> ()) {
        
        let requestURLString = "http://iscoresports.com/bcl/challenge/team.json"

        Request.request(urlString: requestURLString, on: self.defaultSession, completionHandler: { (data) in
            
            do {
                
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] else {
                    
                    errorHandler("An error occurrred parsing the response.")
                    return
                }
                
                completionHandler(dictionary)
                
            } catch {
                
                errorHandler("An error occurrred parsing the response.")
            }
        },
        errorHandler: errorHandler)
    }
    
    /**
     Informs the fact that a user's been tapped.
 
     - parameter player:            Player tapped.
     - parameter team:              Team the player belongs to.
     - parameter completionHandler: Called when completed successfully.
     - parameter errorHandler:      Returns error message.
     */
    func postPlayerTapped(_ player: PlayerModel, from team: TeamModel, completionHandler: @escaping () -> (), errorHandler: @escaping (_ message: String) -> ()) {
        
        let params = ["teamid": String(team.id),
                      "playerid": String(player.id),
                      "firstname": player.firstName,
                      "lastname": player.lastName]
        
        let requestURLString = ParamsFormatter.format(url: "http://iscoresports.com/bcl/challenge/tapped.php", params: params)
        
        Request.request(urlString: requestURLString, on: self.defaultSession, completionHandler: { (data) in

            let response = String(data: data, encoding: .utf8)
            
            if response == "OK" {
                
                completionHandler()
                
            } else {
                
                if let response = response {
                    
                    errorHandler(response)
                    
                } else {
                
                    errorHandler("Invalid response")
                }
            }
        },
        errorHandler: errorHandler)
    }
}
