import Foundation
import UIKit

class PlayerCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "PlayerCollectionViewCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var viewModel: PlayerViewModel? {
        
        didSet {
            
            guard let viewModel = self.viewModel else {
                
                return
            }
            
            self.backgroundColor = viewModel.color
            self.nameLabel.text = viewModel.name
            self.numberLabel.text = viewModel.number
            
            viewModel.fetchPhoto { [weak self] in
                
                guard let strongSelf = self else {
                    
                    return
                }
                
                strongSelf.photoImageView.image = strongSelf.viewModel?.photo
            }
        }
    }
}
