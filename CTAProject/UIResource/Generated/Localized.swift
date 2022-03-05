// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
public enum L10n {
  /// 文字数が50文字を超過しています。
  public static let characterAlertMesssage = L10n.tr("Localizable", "characterAlertMesssage")
  /// 閉じる
  public static let closeButtonTitle = L10n.tr("Localizable", "closeButtonTitle")
  /// お気に入り
  public static let favoriteTabBarTitle = L10n.tr("Localizable", "favoriteTabBarTitle")
  /// リスト
  public static let listTabBarTitle = L10n.tr("Localizable", "listTabBarTitle")
  /// グルスポ
  public static let navigationBarTitle = L10n.tr("Localizable", "navigationBarTitle")
  /// キーワード
  public static let searchBarPlaceholder = L10n.tr("Localizable", "searchBarPlaceholder")
  /// %@ / %@駅
  public static func shopDetailText(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "shopDetailText", String(describing: p1), String(describing: p2))
  }
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
