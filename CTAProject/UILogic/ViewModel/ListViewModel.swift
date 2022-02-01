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
    
    init() {
        $search.flatMapLatest { [weak self] text -> Observable<Event<ShopResponse>> in
            guard let me = self else { return .empty() }
            me.$hud.accept(.progress)
            return APIClient.shared.request(HotPepperAPIService.SearchShopsRequest(keyword: text))
                .asObservable()
                .materialize()
        }.subscribe { [weak self] event in
            guard let me = self else { return }
            switch event.element {
            case .next(let response):
                me.$dataSource.accept([.init(items: response.results.shop)])
                me.$hide.accept(Void())
            case .error(_):
                me.$hud.accept(.error)
            case .completed, .none:
                break
            }
        }.disposed(by: disposeBag)
        
        let _ = $searchText
            .subscribe { [weak self] text in
                guard let me = self,
                      let text = text.element else { return }
                let searchText = me.validCharacters(text: text)
                guard let searchText = searchText else { return }
                me.$validatedText.accept(searchText)
            }.disposed(by: disposeBag)
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
    func validCharacters(text: String) -> String? {
        if text.count >= Const.Search.characterLimit {
            let validCharacters = String(text.prefix(Const.Search.validCharactersCount))
            $alert.accept(Void())
            return validCharacters
        } else {
            return nil
        }
    }
}

// MARK: - Const

extension ListViewModel {
    
    private enum Const {
        enum Search {
            static let characterLimit = 50
            static let validCharactersCount = 50
        }
    }
}
