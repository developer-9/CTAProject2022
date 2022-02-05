//
//  ListViewModel.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/19.
//

import Foundation
import RxSwift
import PKHUD

// MARK: - Protocols

protocol ListViewModelInput {
    var searchText: AnyObserver<String> { get }
    var search: AnyObserver<String> { get }
}

protocol ListViewModelOutput {
    var validatedText: Observable<String> { get }
    var alert: Observable<Void> { get }
    var hud: Observable<HUDContentType> { get }
    var hide: Observable<Void> { get }
    var dataSource: Observable<[ShopResponseSectionModel]> { get }
}

protocol ListViewModelType {
    var inputs: ListViewModelInput { get }
    var outputs: ListViewModelOutput { get }
}

// MARK: - ListViewModelInput, ListViewModelOupt

final class ListViewModel: ListViewModelInput, ListViewModelOutput {
    
    // MARK: Input
    @AnyObserverWrapper var searchText: AnyObserver<String>
    @AnyObserverWrapper var search: AnyObserver<String>
    
    //MARK: Output
    @PublishRelayWrapper var validatedText: Observable<String>
    @PublishRelayWrapper var alert: Observable<Void>
    @PublishRelayWrapper var hud: Observable<HUDContentType>
    @PublishRelayWrapper var hide: Observable<Void>
    @PublishRelayWrapper var dataSource: Observable<[ShopResponseSectionModel]>
    
    private let disposeBag = DisposeBag()
    
    init(hotpepperAPIRepository: HotpepperAPIRepositoryType = HotpepperAPIRepository()) {
                
        $search.flatMapLatest { [weak self] text -> Observable<Event<ShopResponse>> in
            guard let me = self else { return .empty() }
            me.$hud.accept(.progress)
            return hotpepperAPIRepository.request(HotPepperAPIService.SearchShopsRequest(keyword: text))
                .timeout(.seconds(5), scheduler: ConcurrentMainScheduler.instance)
                .asObservable()
                .materialize()
        }.subscribe { [weak self] event in
            guard let me = self else { return }
            switch event.element {
            case .next(let response):
                me.$dataSource.accept([.init(items: response.results.shop)])
                me.$hide.accept(())
            case .error(_):
                me.$hud.accept(.error)
            case .completed, .none:
                break
            }
        }.disposed(by: disposeBag)
        
        $hud.delay(.milliseconds(700), scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let me = self else { return }
                me.$hide.accept(())
            }).disposed(by: disposeBag)

        $searchText.subscribe(onNext: { [weak self] text in
            guard let me = self else { return }
            let validatedText = me.validatedCharacters(text: text)
            me.$validatedText.accept(validatedText)
        }).disposed(by: disposeBag)
    }
}

// MARK: - ListViewModelType

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {
        return self
    }
    
    var outputs: ListViewModelOutput {
        return self
    }
}

// MARK: - Helpers

extension ListViewModel {
    func validatedCharacters(text: String) -> String {
        if text.count >= Const.Search.characterLimit {
            let validCharacters = String(text.prefix(Const.Search.validCharactersCount))
            $alert.accept(())
            return validCharacters
        } else {
            return text
        }
    }
}

// MARK: - Private Const

extension ListViewModel {
    
    private enum Const {
        enum Search {
            static let characterLimit = 50
            static let validCharactersCount = 50
        }
    }
}
