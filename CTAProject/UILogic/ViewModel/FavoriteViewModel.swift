//
//  FavoriteViewModel.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/03/19.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import Unio
import PKHUD

final class FavoriteViewStream: UnioStream<FavoriteViewStream>, FavoriteViewStreamType {

    // MARK: - Initializer

    convenience init(realmManager: RealmRepositoryType = RealmRepository()) {
        self.init(input: Input(), state: State(), extra: Extra(realmManager: realmManager))
    }

    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {
        let input = dependency.inputObservables
        let state = dependency.state
        let extra = dependency.extra

        // MARK: - inputs

        input.load
            .flatMapLatest({ () -> Observable<[FavoriteShop]> in
                return extra.realmManager.get(type: FavoriteShop.self)
            })
            .subscribe(onNext: { objects in
                state.dataSource.accept([.init(items: objects)])
            }).disposed(by: disposeBag)
        
        input.deleteFavorite
            .subscribe(onNext: { id in
                state.hud.accept(.success)
                extra.realmManager.delete(type: FavoriteShop.self, id: id)
                let object = extra.realmManager.getArray(type: FavoriteShop.self)
                let dataSources = [FavoriteShopDataSource(items: object)]
                state.dataSource.accept(dataSources)
            }).disposed(by: disposeBag)
        
        // MARK: Outputs
        
        state.hud
            .filter { $0 == .error || $0 == .success }
            .delay(.milliseconds(700), scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { _ in
                state.hide.accept(())
            }).disposed(by: disposeBag)

        return Output(dataSource: state.dataSource.asObservable(), hud: state.hud.asObservable(),
                      hide: state.hide.asObservable())
    }
}

extension FavoriteViewStream {

    // MARK: - Input

    struct Input: InputType {
        let load = PublishRelay<Void>()
        let favoriteButtonTapped = PublishRelay<Void>()
        let deleteFavorite = PublishRelay<String>()
    }

    // MARK: - Output

    struct Output: OutputType {
        let dataSource: Observable<[FavoriteShopDataSource]>
        let hud: Observable<HUDContentType>
        let hide: Observable<Void>
    }

    // MARK: - State

    struct State: StateType {
        let dataSource = BehaviorRelay<[FavoriteShopDataSource]>(value: [])
        let hud = PublishRelay<HUDContentType>()
        let hide = PublishRelay<Void>()
    }

    // MARK: - Extra

    struct Extra: ExtraType {
        let realmManager: RealmRepositoryType

        init(realmManager: RealmRepositoryType) {
            self.realmManager = realmManager
        }
    }
}
