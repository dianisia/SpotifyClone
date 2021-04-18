//
// Created by Диана Мансурова on 08.04.2021.
//

import UIKit

class CategoryViewController: UIViewController {
    private var category: Category
    private var playlists: [Playlist] = []

    private let collectionView: UICollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
                _, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .fractionalHeight(1))
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .absolute(250)
                        ),
                        subitem: item,
                        count: 2
                )
                return NSCollectionLayoutSection(group: group)
            }))

    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
                FeaturedPlaylistCollectionViewCell.self,
                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self

        APICaller.shared.getCategoryPlaylists(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists.playlists.items
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath
        ) as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: FeaturedPlaylistCellViewModel(
                name: playlist.name,
                artworkURL: URL(string: playlist.images.first?.url ?? ""),
                creatorName: playlist.owner.display_name
        ))
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}