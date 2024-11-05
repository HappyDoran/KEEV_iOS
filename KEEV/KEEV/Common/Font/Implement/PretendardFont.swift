//
//  PretendardFont.swift
//  KEEV
//
//  Created by 김준성 on 10/19/24.
//

import SwiftUI

/// Pretendard Font에서 자주 쓰이는 형태를 나타낸 열거형
///
/// 아래와 같은 case로 구현되어 있습니다.
/// ```swift
/// enum PretendardFont {
///     case title(style: TitleStyle)
///     case body(style: BodyStyle)
///     // ...
/// }
/// ```
///
/// `title`의 경우, 열거형인 `TitleStyle`을 주입해줘야 합니다.
///
/// `TitleStyle`의 경우 `xl`, `lg`, `md`, `sm`, `xs`로 구성되어 있습니다.
///
/// `body`의 경우, 구조체인 `BodyStyle`을 주입해줘야 합니다.
///
/// `BodyStyle`를 생성할 때, `large`, `medium`, `base`, `xsmall`, `xsmall2`, `xsmall3`로 구성된 열거형 `BodySize`와
///
/// `semibold`, `medium`, `regular`, `xsmall`로 구성된 열거형 `BodyWeight`를 추가로 주입해줘야 합니다.
///
/// `BodyWeight`는 굵기에 대한 열거형 케이스를 담고 있습니다.
///
/// 사용법은 아래와 같습니다.
/// - title의 경우:
/// ```swift
/// let title = PretendardFont.title(style: .xl)
/// ```
/// - body의 경우:
/// ```swift
/// let body = PretendardFont.body(style: .init(bodySize: .base, bodyWeight: .medium))
/// ```
///
/// - SeeAlso: PretendardFont.TitleStyle, PretendardFont.BodyStyle
///
/// - Author: newJunsung
enum PretendardFont: FigmaFontable {
    private var name: String { "Pretendard" }
    
    case title(style: TitleStyle)
    case body(style: BodyStyle)
    
    /// 글꼴
    var uiFont: UIFont {
        switch self {
        case .title(let style):
            UIFont(name: "\(name)-Bold", size: style.fontSize)!
        case .body(let style):
            UIFont(name: "\(name)-\(style.weight)", size: style.fontSize)!
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .title(let style):
            style.fontSize
        case .body(let style):
            style.fontSize
        }
    }
    
    /// 행간
    var lineHeight: CGFloat {
        switch self {
        case .title(let style): style.lineHeight
        case .body(let style): style.lineHeight
        }
    }
    
    /// 자간
    var letterSpace: CGFloat {
        switch self {
        case .title(let style): style.letterSpace
        case .body(let style): style.letterSpace
        }
    }
}

// MARK: PretendardFont.TitleStyle
extension PretendardFont {
    /// UI에서 자주 쓰이는 Title의 형태 5가지를 담은 열거형
    ///
    /// `xl`, `lg`, `md`, `sm`, `xs`로 구성되어 있습니다.
    ///
    /// - Font의 size의 경우 아래와 같습니다.
    /// ```swift
    /// var size: CGFloat {
    ///     switch self {
    ///     case .xl: 34
    ///     case .lg: 28
    ///     case .md: 22
    ///     case .sm: 20
    ///     case .xs: 17
    ///     }
    /// }
    /// ```
    ///
    /// - Font의 lineHeight의 경우 아래와 같습니다.
    /// ```swift
    /// var size: CGFloat {
    ///     switch self {
    ///     case .xl: 34
    ///     case .lg: 28
    ///     case .md: 22
    ///     case .sm: 20
    ///     case .xs: 17
    ///     }
    /// }
    /// ```
    ///
    /// - Font의 letterSpace의 경우 아래와 같습니다.
    /// ```swift
    /// var letterSpace: CGFloat {
    ///     switch self {
    ///     case .xl: 0
    ///     case .lg: 0
    ///     case .md: 0
    ///     case .sm: 0
    ///     case .xs: 0
    ///     }
    /// }
    /// ```
    ///
    /// - Todo: 디자인 팀과 상의해서 letterSpace 정해지면 리팩토링하기.
    ///
    /// - Author: newJunsung
    enum TitleStyle: LineHeightable, LetterSpaceable, FontSizeable {
        /// size: 34, lineHeight: 40, letterSpace: 0
        case xl
        /// size: 28, lineHeight: 36, letterSpace: 0
        case lg
        /// size: 22, lineHeight: 30, letterSpace: 0
        case md
        /// size: 20, lineHeight: 28, letterSpace: 0
        case sm
        /// size: 17, lineHeight: 22, letterSpace: 0
        case xs
        
        var fontSize: CGFloat {
            switch self {
            case .xl: 34
            case .lg: 28
            case .md: 22
            case .sm: 20
            case .xs: 17
            }
        }
        
        var lineHeight: CGFloat {
            switch self {
            case .xl: 40
            case .lg: 36
            case .md: 30
            case .sm: 28
            case .xs: 22
            }
        }
        
        var letterSpace: CGFloat {
            switch self {
            case .xl: 0
            case .lg: 0
            case .md: 0
            case .sm: 0
            case .xs: 0
            }
        }
    }
}

// MARK: PretendardFont.BodyStyle
extension PretendardFont {
    /// PretendardFont의 body에 쓰이는 구조체 타입
    ///
    /// 이 타입은 글꼴의 크기, 자간, 행간을 결정하는 `bodySize`와 글꼴의 굵기를 담당하는 `bodyWeight를 담고 있습니다.`
    ///
    /// - SeeAlso: PretendardFont.BodyStyle.BodySize, PretendardFont.BodyStyle.BodyWeight
    /// - Author: newJunsung
    struct BodyStyle: LineHeightable, LetterSpaceable, FontSizeable {
        private let bodySize: BodySize
        private let bodyWeight: BodyWeight
        
        init(bodySize: BodySize, bodyWeight: BodyWeight) {
            self.bodySize = bodySize
            self.bodyWeight = bodyWeight
        }
        
        var fontSize: CGFloat { bodySize.fontSize }
        var weight: String { bodyWeight.rawValue }
        var lineHeight: CGFloat { bodySize.lineHeight }
        var letterSpace: CGFloat { bodySize.letterSpace }
    }
}

// MARK: PretendardFont.BodyStyle.BodyWeight, PretendardFont.BodyStyle.BodySize
extension PretendardFont.BodyStyle {
    /// 글꼴의 굵기를 결정하는 열거형
    ///
    /// 기본적으로 String을 담고있기 때문에, `rawValue`를 보시면 각 케이스를 camelCase로 반환합니다.
    /// 예시로 `BodyWeight.semibold`의 `rawValue`는 `SemiBold`입니다.
    ///
    /// - Author: newJunsung
    enum BodyWeight: String {
        case semibold = "SemiBold"
        case medium = "Medium"
        case regular = "Regular"
    }
    
    /// BodyStyle에 들어갈 FontSize를 결정하는 열거형
    ///
    /// `large`, `medium`, `base`, `xsmall`, `xsmall2`, `xsmall3`로 구성되어 있으며
    /// 각각의 케이스는 글꼴의 크기, 행간, 자간을 결정합니다.
    /// 자세한 내용은 각 케이스의 QuickHelp를 보시면 확인할 수 있습니다.
    ///
    /// - Note: 아직 자간은 0으로 통일되어 있습니다.
    /// - Todo: 디자인 팀과 상의해서 letterSpace 정해지면 리팩토링하기.
    /// - Author: newJunsung
    enum BodySize: FontSizeable, LineHeightable, LetterSpaceable {
        case xlarge
        /// size: 17, lineHeight: 24, letterSpace: 0
        case large
        /// size: 16, lineHeight: 22, letterSpace: 0
        case medium
        /// size: 15, lineHeight: 21, letterSpace: 0
        case base
        /// size: 13, lineHeight: 17, letterSpace: 0
        case xsmall
        /// size: 12, lineHeight: 15, letterSpace: 0
        case xsmall2
        /// size: 11, lineHeight: 13, letterSpace: 0
        case xsmall3
        
        var fontSize: CGFloat {
            switch self {
            case .xlarge: 20
            case .large: 17
            case .medium: 16
            case .base: 15
            case .xsmall: 13
            case .xsmall2: 12
            case .xsmall3: 11
            }
        }
        
        var lineHeight: CGFloat {
            switch self {
            case .xlarge: 22
            case .large: 24
            case .medium: 22
            case .base: 21
            case .xsmall: 17
            case .xsmall2: 15
            case .xsmall3: 13
            }
        }
        
        var letterSpace: CGFloat {
            switch self {
            case .xlarge: 0
            case .large: 0
            case .medium: 0
            case .base: 0
            case .xsmall: 0
            case .xsmall2: 0
            case .xsmall3: 0
            }
        }
    }
}
