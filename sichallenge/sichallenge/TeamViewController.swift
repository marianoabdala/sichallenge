import UIKit

class TeamViewController: UICollectionViewController {

    private let viewModel = TeamViewModel(withClient: SIClient())
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupNavigationBar()
        
        self.viewModel.loadTeam { [weak self] in
            
            self?.updateUI()
        }
    }
}

extension TeamViewController {
    
    private func setupNavigationBar() {
        
        self.activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        self.activityIndicatorView.startAnimating()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicatorView)
    }
    
    private func updateUI() {
        
        if self.viewModel.hasError {
        
            let alertController = UIAlertController(title: "Error", message: self.viewModel.errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
        
            self.title = self.viewModel.name
        }

        self.collectionView?.reloadData()
        self.activityIndicatorView.stopAnimating()
    }
}

extension TeamViewController { // UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.viewModel.players.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerCollectionViewCell.cellId, for: indexPath) as? PlayerCollectionViewCell else {
        
            return UICollectionViewCell()
        }
        
        cell.viewModel = self.viewModel.players[indexPath.row]
        
        return cell
    }
}

extension TeamViewController { // UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let player = self.viewModel.players[indexPath.row]
        
        self.viewModel.recordSelected(player) {

            if self.viewModel.hasError {
                
                let alertController = UIAlertController(title: "Error", message: self.viewModel.errorMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension TeamViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - 8) / 3
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
}
