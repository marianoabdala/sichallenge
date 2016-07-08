import Foundation
import UIKit

class PlayerViewModel {
    
    let model: PlayerModel
    
    let id: Int
    let color: UIColor
    let name: String
    let number: String
    var photo: UIImage?
    var isFetchingPhoto = false

    init(with model: PlayerModel, in team: TeamViewModel) {
        
        self.model = model
        self.id = model.id
        self.color = team.color
        
        let firstName = model.firstName ?? "??"
        let lastName = model.lastName ?? "??"
        
        self.name = "\(firstName)\n\(lastName)"
        self.number = model.number ?? "??"
    }
    
    func fetchPhoto(withCompletion completionHandler: () -> ()) {
        
        guard let url = self.model.photoUrl where self.isFetchingPhoto == false else {
            
            return
        }
        
        if self.photo != nil {
            
            completionHandler()
            return
        }
        
        self.isFetchingPhoto = true
        
        let downloadThumbnailTask = URLSession.shared.downloadTask(with: url) { [weak self] (url, urlResponse, error) in
            
            guard let url = url,
                data = NSData(contentsOf: url),
                image = UIImage(data: data as Data) else {
                    
                    return
            }
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else {
                    
                    return
                }
                
                strongSelf.isFetchingPhoto = false
                strongSelf.photo = image
                completionHandler()
            }
        }
        
        downloadThumbnailTask.resume()
    }
}
