//
//  DetailInfoView.swift
//  UnsplashPics
//
//  Created by 1 on 17.02.2025.
//

import UIKit
import SkeletonView

protocol DetailInfoViewDelegate: AnyObject {
    func didTapContainer(with user: User)
    func didTapFavoriteButton(for photo: DetailPhoto)
    func didTapShare(_ photo: DetailPhoto)
    func showSnackbar(message: String)
    func reloadData()
}

class DetailInfoView: UIView {
    
    enum State {
        case error(errorMessage: String)
        case loading(isLoading: Bool)
        case empty
        case normal(photo: DetailPhoto)
    }
    
    weak var delegate: DetailInfoViewDelegate?
    
    private let asyncImage = AsyncImageView(cornerRadius: 40)
    private let descriptionTitleLabel = CustomLabel(type: .title, numberOfLines: 1)
    private let descriptionLabel = CustomLabel(type: .secondary, numberOfLines: 4)
    private let authorTitleLabel = CustomLabel(type: .title, numberOfLines: 1)
    private let stateView = StateView()
    private let userInfoContainer = InfoContianer()
    private var addToFavoritsButton = CustomButton(type: .iconWithText,
                                                icon: .add,
                                                mainColor: .systemPink)
    private let menu = CustomMenu()
    private let backgroundView = CustomBackgroundView(mainBackgroundColor: .tertiarySystemGroupedBackground,
                                                      cornerRadius: 40,
                                                      maskedCorners: .upperCorners)
    private var photo: DetailPhoto?
    var isFavorite = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setupTitles()
    }
    
    func updateFavoriteButtonTitle() {
        let title = isFavorite ? "Удалить из избранного" : "Добавить в избранное"
        addToFavoritsButton.setTitle(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(state: State) {
        switch state {
        case .error(let errorMessage):
            stateView.configure(for: .error(errorText: errorMessage))
        case .loading(let isLoading):
            stateView.configure(for: .loading(isLoading: isLoading))
        case .empty:
            break
        case .normal(let photo):
            stateView.configure(for: .default)
            
            self.photo = photo
            descriptionLabel.set(photo.altDescription?.capitalized ?? "Нет информации")
            Task { await asyncImage.setImage(for: photo.urls.regular) }
            userInfoContainer.set(with: photo)
            userInfoContainer.handleTap = {
                self.delegate?.didTapContainer(with: photo.user)
            }
            stateView.isHidden = true
            updateFavoriteButtonTitle()
        }
       
    }
    
    func configureView(with navItem: UINavigationItem) {
        backgroundColor = .systemBackground
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: setupMenu())
        descriptionTitleLabel.set("Описание")
        authorTitleLabel.set("Автор")
        stateView.onReloadTap = { self.delegate?.reloadData() }
    }
    
    func setupMenu() -> UIMenu {
         menu.onShareTap = {
             guard let photo = self.photo else { return }
             
             self.delegate?.didTapShare(photo)
         }
         
         menu.onDowloadToGalleryTap = {
             self.didTapSaveToGallery()
         }
         
        return menu.createMenu()
    }
    
    private func didTapSaveToGallery() {
        guard let photo else { return }
        
        Task {
            do {
                try await ImageSaver.shared.saveImage(photo)
                delegate?.showSnackbar(message: "Изображение сохранено 🎉")
            } catch let error as ImageSaveError {
                delegate?.showSnackbar(message: error.description)
            } catch {
                delegate?.showSnackbar(message: "Произошла неизвестная ошибка.")
            }
        }
    }
}


private extension DetailInfoView {
    func initialize() {
        embedViews()
        configureConstraints()
        addToFavoritsButton.onTap = {
            guard let photo = self.photo else { return }
            
            self.delegate?.didTapFavoriteButton(for: photo)
        }
    }
    
    func embedViews() {
        addSubviews(asyncImage, backgroundView, stateView)
        backgroundView.addSubviews(descriptionTitleLabel,
                                   descriptionLabel,
                                   authorTitleLabel,
                                   userInfoContainer,
                                   addToFavoritsButton)
    }
    
    func configureConstraints() {
        stateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        asyncImage.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(asyncImage.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(15)
        }
        
        authorTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(5)
        }
        
        userInfoContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(authorTitleLabel.snp.bottom).offset(10)
        }
        
        addToFavoritsButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func setupTitles() {
        [descriptionTitleLabel, authorTitleLabel].forEach {
            $0.updateStyle(textColor: .secondaryLabel, alignment: .left)
        }
    }
}
