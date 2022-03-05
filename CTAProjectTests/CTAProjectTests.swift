//
//  CTAProjectTests.swift
//  CTAProjectTests
//
//  Created by 田中 颯志 on 2021/12/29.
//
@testable import CTAProject
import RxSwift
import XCTest

class CTAProjectTests: XCTestCase {

    // MARK: - Properties

    var dependency: Dependency!

    // MARK: - TestMethods

    /// searchButtonを押下した時のAPI取得成功時のテスト
    func test_searchButtonClicked_success() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let repository = dependency.hotpepperRepositoryMock
        let hud = WatchStream(testTarget.output.hud)
        let datasource = WatchStream(testTarget.output.dataSource)
        let hide = WatchStream(testTarget.output.hide)
        var keyword: String?

        XCTAssertEqual(repository.searchRequestCallCount, 0, "searchRequestメソッドが呼ばれていないか")
        repository.searchRequestHandler = { text in
            keyword = text
            return TestMockData.fetchSingleShops()
        }

        testTarget.input.searchText.onNext(TestMockData.mockText)
        testTarget.input.searchButtonClicked.onNext(())
        XCTAssertEqual(repository.searchRequestCallCount, 1, "searchRequestメソッドが一回呼ばれているか")
        XCTAssertEqual(hud.value, .progress, "プログレスHUDが表示されているか")
        XCTAssertEqual(keyword, TestMockData.mockText, "検索文字を流せているか")
        XCTAssertEqual(datasource.value?[0].items, TestMockData.fetchShops(), "モックデータの検索結果が返ってくるか")
        XCTAssertNotNil(hide.value, "HUDが非表示になっているか")
    }

    /// searchButtonを押下した時のAPI取得失敗時のテスト
    func test_searchButtonClicked_failure() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let repository = dependency.hotpepperRepositoryMock
        let hud = WatchStream(testTarget.output.hud)
        let hide = WatchStream(testTarget.output.hide)

        XCTAssertEqual(repository.searchRequestCallCount, 0, "searchRequestメソッドが呼ばれていないか")
        repository.searchRequestHandler = { _ in
            return Single.error(MockError.error)
        }

        testTarget.input.searchText.onNext(TestMockData.mockText)
        testTarget.input.searchButtonClicked.onNext(())
        XCTAssertEqual(repository.searchRequestCallCount, 1, "searchRequestメソッドが一回呼ばれているか")
        XCTAssertEqual(hud.value, .error, "エラーHUDが表示されること")
        XCTAssertNil(hide.value, "HUDが非表示になっているか")
    }

    /// 50文字以上のテキストを入力した場合のテスト
    func test_inputSeachText_over50Characters() {
        dependency = Dependency()
        let testTarget = dependency.testTarget
        let over50Characters = String(repeating: "a", count: 51)
        let validatedText = WatchStream(testTarget.output.validatedText)
        let alert = WatchStream(testTarget.output.alert)

        testTarget.input.searchText.onNext(over50Characters)
        testTarget.input.editingChanged.onNext(())
        XCTAssertEqual(validatedText.value?.count, 50, "50文字以内に加工されているか")
        XCTAssertNotNil(alert.value, "50文字以上でアラートが表示されるか")
    }
}

// MARK: - DependencyInjection

extension CTAProjectTests {
    struct Dependency {
        let testTarget: ListViewStream
        let hotpepperRepositoryMock: HotpepperRepositoryTypeMock

        init() {
            self.hotpepperRepositoryMock = HotpepperRepositoryTypeMock()
            testTarget = ListViewStream(hotpepperApiRepository: hotpepperRepositoryMock)
        }
    }
}
