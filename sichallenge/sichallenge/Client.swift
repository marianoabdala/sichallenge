import Foundation

protocol Client {
    
    func fetch(completionHandler:([String: AnyObject]) -> (), errorHandler:(message: String) -> ())
    func postPlayerTapped(_ player: PlayerModel, from team: TeamModel, completionHandler:() -> (), errorHandler:(message: String) -> ())
}
