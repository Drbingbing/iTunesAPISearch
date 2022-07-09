//
//  ViewController.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import UIKit
import RxSwift
import AVKit
import RxCocoa

class SearchResultViewController: UIViewController, Storyboarded {
    
    static var storyboardName: String { return "Main" }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var iTunesSearchAPI: iTunesSearchAPIProtocol!
    var musicDownloadHandler: MusicDownloadHandlerProtocol!
    var avFoundationHandler: AVFoundationHandlerProtocol!
    
    private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "iTunesSearch"
        self.navigationItem.searchController = searchController
        self.setupAudio()
        self.setupTableView()
        self.configureKeyboardDismissesOnScroll()
        self.binding()
    }
    
    private func setupAudio() {
        self.avFoundationHandler.active()
    }
    
    
    private func setupTableView() {
        tableView.register(SearchResultCell.nib, forCellReuseIdentifier: SearchResultCell.identifier)
    }
    
    private func binding() {
        
        let iTunesSearchAPI = self.iTunesSearchAPI!
        
        let searchBar = searchController.searchBar
        
        let result = searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(.milliseconds(300))
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMapLatest { query in
                iTunesSearchAPI.search(query: query)
                    .map(\.results)
                    .startWith([])
                    .asDriver { error in
                        print(error)
                        return Driver.just([])
                    }
            }
            .map { result in
                result.map(SearchResultViewModel.init)
            }
        
        result
            .drive(tableView.rx.items(cellIdentifier: SearchResultCell.identifier, cellType: SearchResultCell.self)) { [weak self] (index, viewModel, cell) in
                guard let self = self else { return }
                
                viewModel.index = index
                if let path = self.musicDownloadHandler.localMusicPath(withURL: viewModel.previewURL) {
                    viewModel.downloadState = .downloaded(destinationPath: path)
                }
                
                cell.viewModel = viewModel
                cell.onPlayClicked
                    .subscribe(onNext: {
                        self.handlePlayBackButtonActions(for: viewModel)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchResultViewModel.self)
            .asDriver()
            .drive(onNext: { [weak self] viewModel in
                self?.handlePlayBackButtonActions(for: viewModel)
            })
            .disposed(by: disposeBag)
        
        let downloadHandler = self.musicDownloadHandler!
        
        downloadHandler.downloadCompletionSubject
            .asObserver()
            .subscribe(onNext: { [weak self] download in
                self?.updateRow(at: download.index)
            })
            .disposed(by: disposeBag)
        
        downloadHandler.downloadProgressSubject
            .asObserver()
            .subscribe(onNext: { [weak self] download in
                self?.updateRow(at: download.index)
            })
            .disposed(by: disposeBag)
        
        let avFoundationHandler = self.avFoundationHandler!
        
        avFoundationHandler.playerSubject
            .asObserver()
            .subscribe(onNext: { [weak self] asset in
                self?.reloadRowWhenMusicStopped(for: asset)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureKeyboardDismissesOnScroll() {
        let searchBar = self.searchController.searchBar
        
        tableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                if searchBar.isFirstResponder {
                    searchBar.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UI Update Events
extension SearchResultViewController {
    
    private func reloadRowWhenMusicStopped(for asset: Asset) {
        if let viewModel = asset as? SearchResultViewModel {
            viewModel.isPlaying = false
            updateRow(at: viewModel.index)
        }
    }
    
    private func updateRow(at index: Int?) {
        guard let index = index else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}


// MARK: - Cell Button Events
extension SearchResultViewController {
    
    private func handlePlayBackButtonActions(for viewModel: SearchResultViewModel) {
        switch viewModel.downloadState {
        case .notDownloaded:
            self.startDownloadMusic(for: viewModel)
        case .downloaded:
            if viewModel.isPlaying {
                self.stopPlayingMusic()
            } else {
                self.startPlayingMusic(for: viewModel)
            }
            
            viewModel.isPlaying.toggle()
        case .downloading:
            break
        }
        
        self.updateRow(at: viewModel.index)
    }
}


// MARK: - Music Events
extension SearchResultViewController {
    
    private func startPlayingMusic(for asset: Asset) {
        self.avFoundationHandler.startPlaying(for: asset)
    }
    
    private func stopPlayingMusic() {
        self.avFoundationHandler.stopPlaying()
    }
    
    private func startDownloadMusic(for asset: Asset) {
        musicDownloadHandler.downloadMusic(for: asset)
    }
}

