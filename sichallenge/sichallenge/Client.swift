import Foundation

protocol Client {
    
    func fetch(completionHandler: @escaping ([String : AnyObject]) -> (), errorHandler: @escaping (_ message: String) -> ())
    func postPlayerTapped(_ player: PlayerModel, from team: TeamModel, completionHandler: @escaping () -> (), errorHandler: @escaping (_ message: String) -> ())
}
