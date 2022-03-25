//
//  RealmManager.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/03/12.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

protocol RealmRepositoryType {
    /// 全ての要素を取得する
    func get<O: Object>(type: O.Type) -> Observable<[O]>
    /// 全ての要素をArray型で取得する
    func getArray<O: Object>(type: O.Type) -> Array<O>
    /// お気に入りリストに保存する
    func add<O: Object>(object: O)
    /// お気に入りリストから削除する
    func delete<O: Object>(type: O.Type, id: String)
}

final class RealmRepository: RealmRepositoryType {

    private let disposeBag: DisposeBag

    init() {
        self.disposeBag = DisposeBag()
    }

    func get<O: Object>(type: O.Type) -> Observable<[O]> {
        do {
            let realm = try Realm()
            let objects = realm.objects(type).toArray()
            return .just(objects)
        } catch _ {
            return .just([])
        }
    }
    
    func getArray<O: Object>(type: O.Type) -> Array<O> {
        let realm = try! Realm()
        return realm.objects(type.self).toArray()
    }

    func add<O: Object>(object: O) {
        do {
            let realm = try Realm()
            Observable.from(object: object)
                .subscribe(realm.rx.add(update: .modified))
                .disposed(by: disposeBag)
        } catch let error {
            print("DEBUG: Error occurred.", error)
        }
    }
    
    func delete<O: Object>(type: O.Type, id: String) {
        do {
            let realm = try Realm()
            let object = realm.objects(type.self).filter("id == '\(id)'")
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print("DEBUG: Error occurred.", error)
        }
    }
}
