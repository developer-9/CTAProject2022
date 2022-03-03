//
//  ListViewModel.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/19.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD
import Unio

protocol ListViewModelStreamType: AnyObject {
    var input: InputWrapper<ListViewStream.Input> { get }
    var output: OutputWrapper<ListViewStream.Output> { get }
}

final class ListViewStream: UnioStream<ListViewStream>, ListViewModelStreamType {
    
    // MARK: - Initializer
    
    convenience init(hotpepperApiRepository: HotpepperRepositoryType = HotpepperRepository()) {
        self.init(input: Input(), state: State(), extra: Extra(hotpepperApiRepository: hotpepperApiRepository))
    }
    
    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {
        let input = dependency.inputObservables
        let state = dependency.state
        let extra = dependency.extra
        
        input.searchButtonClicked
            .withLatestFrom(input.searchText)
            .flatMapLatest { text -> Single<[Shop]> in
                state.hud.accept(.progress)
                return extra.hotpepperApiRepository.searchRequest(keyword: text)
                    .timeout(.seconds(5), scheduler: ConcurrentMainScheduler.instance)
            }.subscribe(onNext: { shops in
                state.datasource.accept([.init(items: shops)])
                state.hide.accept(())
            }, onError: { _ in
                state.hud.accept(.error)
            }).disposed(by: disposeBag)
        
        input.editingChanged
            .withLatestFrom(input.searchText)
            .subscribe(onNext: { text in
                let validatedText = validatedCharacters(text: text, state: state)
                state.validatedText.accept(validatedText)
            }).disposed(by: disposeBag)
        
        state.hud
            .filter { $0 == .error }
            .delay(.milliseconds(700), scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { _ in
                state.hide.accept(())
            }).disposed(by: disposeBag)
        
        return Output(validatedText: state.validatedText.asObservable(), alert: state.alert.asObservable(), hud: state.hud.asObservable(), hide: state.hide.asObservable(), dataSource: state.datasource.asObservable())
    }
}

extension ListViewStream {
    
    // MARK: - Input
    
    struct Input: InputType {
        let searchText = PublishRelay<String>()
        let searchButtonClicked = PublishRelay<Void>()
        let editingChanged = PublishRelay<Void>()
    }
    
    // MARK: - Output
    
    struct Output: OutputType {
        let validatedText: Observable<String>
        let alert: Observable<Void>
        let hud: Observable<HUDContentType>
        let hide: Observable<Void>
        let dataSource: Observable<[ShopResponseSectionModel]>
    }
    
    // MARK: - State
    
    struct State: StateType {
        let validatedText = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let hud = PublishRelay<HUDContentType>()
        let hide = PublishRelay<Void>()
        let datasource = BehaviorRelay<[ShopResponseSectionModel]>(value: [])
    }
    
    // MARK: - Extra
    
    struct Extra: ExtraType {
        let hotpepperApiRepository: HotpepperRepositoryType
        
        init(hotpepperApiRepository: HotpepperRepositoryType) {
            self.hotpepperApiRepository = hotpepperApiRepository
        }
    }
}

// MARK: - Helpers

extension ListViewStream {
    private static func validatedCharacters(text: String, state: State) -> String {
        if text.count >= Const.Search.characterLimit {
            let validCharacters = String(text.prefix(Const.Search.validCharactersCount))
            state.alert.accept(())
            return validCharacters
        } else {
            return text
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
