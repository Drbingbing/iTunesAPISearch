//
//  SearchResultCell.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/8.
//

import UIKit
import RxSwift
import Kingfisher
import RxKingfisher

class SearchResultCell: UITableViewCell {
    
    static let nib = UINib(nibName: "SearchResultCell", bundle: nil)
    static let identifier = "SearchResultCell"
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    var disposeBag = DisposeBag()
    
    var onPlayClicked: Observable<Void> {
        self.downloadButton.rx.tap.asObservable()
    }
    
    var viewModel: SearchResultViewModel? {
        didSet {
            self.configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func configure() {
        guard let viewModel = viewModel else { return }
        
        self.artworkImageView.kf.setImage(with: viewModel.artWorkURL)
        self.trackNameLabel.text = viewModel.trackName
        self.artistNameLabel.text = viewModel.artistName
        
        switch viewModel.downloadState {
        case .notDownloaded:
            self.progressView.isHidden = true
            self.progressLabel.isHidden = true
            self.downloadButton.isHidden = false
            self.downloadButton.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
            
        case .downloaded:
            self.progressView.isHidden = true
            self.progressLabel.isHidden = true
            self.downloadButton.isHidden = false
            
            let icon = viewModel.isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play")
            self.downloadButton.setImage(icon, for: .normal)
            
        
        case let .downloading(progress, totalSize):
            self.progressView.isHidden = false
            self.progressLabel.isHidden = false
            self.downloadButton.isHidden = true
            
            self.progressView.progress = progress
            self.progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
