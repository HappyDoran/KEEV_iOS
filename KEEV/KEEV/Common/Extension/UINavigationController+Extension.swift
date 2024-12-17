//
//  UINavigationController+Extension.swift
//  KEEV
//
//  Created by Yune Cho on 12/17/24.
//

import Foundation
import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    /// viewDidLoad 함수를 override한 함수
    ///
    /// UIGestureRecognizerDelegate의 viewDidLoad 함수를 override한 함수입니다.
    ///
    /// 커스텀 네비게이션바를 사용하고 기존의 NavigationBar를 hide하면서 비활성화된 PopGesture를 다시 활성화함으로써 네비게이션 제스처를 통해 dismiss가 동작하도록 하였습니다.
    ///
    /// - Author: 라움
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    /// NavigationStack에 쌓인 뷰가 1개를 초과할 때 제스쳐 인식이 되도록 하는 함수
    ///
    /// - Parameters:
    ///   - gestureRecognizer: UIGestureRecognizer
    ///
    /// NavigationStack에 쌓인 뷰가 1개를 초과할 때 제스쳐 인식이 되도록 하는 함수입니다.
    ///
    /// - Returns: NavigationStack에 쌓인 뷰가 1개를 초과할 경우 true를 리턴
    ///
    /// - Author: 라움
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
