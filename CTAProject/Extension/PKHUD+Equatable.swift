//
//  PKHUD+Equatable.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/02/22.
//

import Foundation
import PKHUD

extension HUDContentType: Equatable {
    public static func == (lhs: HUDContentType, rhs: HUDContentType) -> Bool {
        switch lhs {
        case .success:
            if case .success = rhs { return true } else { return false }

        case .error:
            if case .error = rhs { return true } else { return false }

        case .progress:
            if case .progress = rhs { return true } else { return false }

        case .image:
            if case .image = rhs { return true } else { return false }

        case .rotatingImage(let optional):
            if case .rotatingImage(optional) = rhs { return true } else { return false }

        case .labeledSuccess(let title, let subtitle):
            if case .labeledSuccess(title: title, subtitle: subtitle) = rhs { return true } else { return false }

        case .labeledError(let title, let subtitle):
            if case .labeledError(title: title, subtitle: subtitle) = rhs { return true } else { return false }

        case .labeledProgress(let title, let subtitle):
            if case .labeledProgress(title: title, subtitle: subtitle) = rhs { return true } else { return false }

        case .labeledImage(let image, let title, let subtitle):
            if case .labeledImage(image: image, title: title, subtitle: subtitle) = rhs { return true } else { return false }

        case .labeledRotatingImage(let image, let title, let subtitle):
            if case .labeledRotatingImage(image: image, title: title, subtitle: subtitle) = rhs { return true } else { return false }

        case .label(let optional):
            if case .label(optional) = rhs { return true } else { return false }

        case .systemActivity:
            if case .systemActivity = rhs { return true } else { return false }

        case .customView(let view):
            if case .customView(view: view) = rhs { return true } else { return false }
        }
    }
}
