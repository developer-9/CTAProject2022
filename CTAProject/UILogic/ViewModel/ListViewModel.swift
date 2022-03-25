//
//  ListViewModel.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/19.
//

import Foundation
import PKHUD
import RxCocoa
import RxSwift
import Unio

final class ListViewStream: UnioStream<ListViewStream>, ListViewStreamType {

    // MARK: - Initializer

    convenience init(hotpepperApiRepository: HotpepperRepositoryType = HotpepperRepository(),
                     realmManager: RealmRepositoryType = RealmRepository()) {
        self.init(input: Input(), state: State(), extra: Extra(hotpepperApiRepository: hotpepperApiRepository,
                                                               realmManager: realmManager))
    }

    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {
        let input = dependency.inputObservables
        let state = dependency.state
        let extra = dependency.extra

        // MARK: Inputs

        input.searchButtonClicked
            .withLatestFrom(input.searchText)
            .flatMapLatest { text -> Single<[Shop]?> in
                state.hud.accept(.progress)
                return extra.hotpepperApiRepository.searchRequest(keyword: text)
                    .timeout(.seconds(5), scheduler: ConcurrentMainScheduler.instance)
                    .map(Optional.some)
                    .catch { error in
                        state.hud.accept(.error)
                        return .just(nil)
                    }
            }.subscribe(onNext: { shops in
                guard let shops = shops else { return }
                state.datasource.accept([.init(items: shops)])
                state.hide.accept(())
            }).disposed(by: disposeBag)

        input.editingChanged
            .withLatestFrom(input.searchText)
            .filter { $0.count > Const.Search.characterLimit }
            .subscribe(onNext: { text in
                let validatedText = "\(text.prefix(Const.Search.validCharactersCount))"
                state.validatedText.accept(validatedText)
                state.alert.accept(())
            }).disposed(by: disposeBag)

        input.addFavorite
            .subscribe(onNext: { shop in
                state.hud.accept(.success)
                let object = FavoriteShop(shop: shop)
                extra.realmManager.add(object: object)
            }, onError: { _ in
                state.hud.accept(.error)
            }).disposed(by: disposeBag)

        input.deleteFavorite
            .subscribe(onNext: { id in
                state.hud.accept(.success)
                extra.realmManager.delete(type: FavoriteShop.self, id: id)
            }, onError: { _ in
                state.hud.accept(.error)
            }).disposed(by: disposeBag)
        
        // MARK: States

        state.hud
            .filter { $0 == .error || $0 == .success }
            .delay(.milliseconds(700), scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { _ in
                state.hide.accept(())
            }).disposed(by: disposeBag)

        return Output(validatedText: state.validatedText.asObservable(), alert: state.alert.asObservable(),
                      hud: state.hud.asObservable(), hide: state.hide.asObservable(),
                      dataSource: state.datasource.asObservable())
    }
}

extension ListViewStream {

    // MARK: - Input

    struct Input: InputType {
        let searchText = PublishRelay<String>()
        let searchButtonClicked = PublishRelay<Void>()
        let editingChanged = PublishRelay<Void>()
        let favoriteState = BehaviorRelay<Bool>(value: false)
        let favoriteButtonTapped = PublishRelay<Void>()
        let addFavorite = PublishRelay<Shop>()
        let deleteFavorite = PublishRelay<String>()
    }

    // MARK: - Output

    struct Output: OutputType {
        let validatedText: Observable<String>
        let alert: Observable<Void>
        let hud: Observable<HUDContentType>
        let hide: Observable<Void>
        let dataSource: Observable<[ShopResponseDataSource]>
    }

    // MARK: - State

    struct State: StateType {
        let validatedText = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let hud = PublishRelay<HUDContentType>()
        let hide = PublishRelay<Void>()
        let datasource = BehaviorRelay<[ShopResponseDataSource]>(value: [])
    }

    // MARK: - Extra

    struct Extra: ExtraType {
        let hotpepperApiRepository: HotpepperRepositoryType
        let realmManager: RealmRepositoryType

        init(hotpepperApiRepository: HotpepperRepositoryType, realmManager: RealmRepositoryType) {
            self.hotpepperApiRepository = hotpepperApiRepository
            self.realmManager = realmManager
        }
    }
}

// MARK: - Private Const

extension ListViewStream {

    private enum Const {
        enum Search {
            static let characterLimit = 50
            static let validCharactersCount = 50
        }
    }
}
