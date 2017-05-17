//
//  ViewController.swift
//  Button Extension
//
//  Created by Daniel Vebman on 12/30/16.
//  Copyright © 2016 Brinklet. All rights reserved.
//

import UIKit

extension UIButton {
    private struct Actions {
        static var touchDown = {}
        static var touchDownRepeat = {}
        static var touchDragInside = {}
        static var touchDragOutside = {}
        static var touchDragEnter = {}
        static var touchDragExit = {}
        static var touchUpInside = {}
        static var touchUpOutside = {}
        static var touchCancel = {}
        static var valueChanged = {}
        static var primaryActionTriggered = {}
        static var editingDidBegin = {}
        static var editingChanged = {}
        static var editingDidEnd = {}
        static var editingDidEndOnExit = {}
        static var allTouchEvents = {}
        static var allEditingEvents = {}
        static var applicationReserved = {}
        static var systemReserved = {}
        static var allEvents = {}
    }
    
    func setTouchDown(_ action: @escaping () -> ()) {
        Actions.touchDown = action
        addTarget(self, action: #selector(touchDown), for: .touchDown)
    }
    
    @objc private func touchDown() {
        Actions.touchDown()
    }
    
    func setTouchDownRepeat(_ action: @escaping () -> ()) {
        Actions.touchDownRepeat = action
        addTarget(self, action: #selector(touchDownRepeat), for: .touchDownRepeat)
    }
    
    @objc private func touchDownRepeat() {
        Actions.touchDownRepeat()
    }
    
    func setTouchDragInside(_ action: @escaping () -> ()) {
        Actions.touchDragInside = action
        addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
    }
    
    @objc private func touchDragInside() {
        Actions.touchDragInside()
    }
    
    func setTouchDragOutside(_ action: @escaping () -> ()) {
        Actions.touchDragOutside = action
        addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
    }
    
    @objc private func touchDragOutside() {
        Actions.touchDragOutside()
    }
    
    func setTouchDragEnter(_ action: @escaping () -> ()) {
        Actions.touchDragEnter = action
        addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
    }
    
    @objc private func touchDragEnter() {
        Actions.touchDragEnter()
    }
    
    func setTouchDragExit(_ action: @escaping () -> ()) {
        Actions.touchDragExit = action
        addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
    }
    
    @objc private func touchDragExit() {
        Actions.touchDragExit()
    }
    
    func setTouchUpInside(_ action: @escaping () -> ()) {
        Actions.touchUpInside = action
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc private func touchUpInside() {
        Actions.touchUpInside()
    }
    
    func setTouchUpOutside(_ action: @escaping () -> ()) {
        Actions.touchUpOutside = action
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
    }
    
    @objc private func touchUpOutside() {
        Actions.touchUpOutside()
    }
    
    func setTouchCancel(_ action: @escaping () -> ()) {
        Actions.touchCancel = action
        addTarget(self, action: #selector(touchCancel), for: .touchCancel)
    }
    
    @objc private func touchCancel() {
        Actions.touchCancel()
    }
    
    func setValueChanged(_ action: @escaping () -> ()) {
        Actions.valueChanged = action
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc private func valueChanged() {
        Actions.valueChanged()
    }
    
    func setPrimaryActionTriggered(_ action: @escaping () -> ()) {
        Actions.primaryActionTriggered = action
        addTarget(self, action: #selector(primaryActionTriggered), for: .primaryActionTriggered)
    }
    
    @objc private func primaryActionTriggered() {
        Actions.primaryActionTriggered()
    }
    
    func setEditingDidBegin(_ action: @escaping () -> ()) {
        Actions.editingDidBegin = action
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
    }
    
    @objc private func editingDidBegin() {
        Actions.editingDidBegin()
    }
    
    func setEditingChanged(_ action: @escaping () -> ()) {
        Actions.editingChanged = action
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc private func editingChanged() {
        Actions.editingChanged()
    }
    
    func setEditingDidEnd(_ action: @escaping () -> ()) {
        Actions.editingDidEnd = action
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    @objc private func editingDidEnd() {
        Actions.editingDidEnd()
    }
    
    func setEditingDidEndOnExit(_ action: @escaping () -> ()) {
        Actions.editingDidEndOnExit = action
        addTarget(self, action: #selector(editingDidEndOnExit), for: .editingDidEndOnExit)
    }
    
    @objc private func editingDidEndOnExit() {
        Actions.editingDidEndOnExit()
    }
    
    func setAllTouchEvents(_ action: @escaping () -> ()) {
        Actions.allTouchEvents = action
        addTarget(self, action: #selector(allTouchEvents), for: .allTouchEvents)
    }
    
    @objc private func allTouchEvents() {
        Actions.allTouchEvents()
    }
    
    func setAllEditingEvents(_ action: @escaping () -> ()) {
        Actions.allEditingEvents = action
        addTarget(self, action: #selector(allEditingEvents), for: .allEditingEvents)
    }
    
    @objc private func allEditingEvents() {
        Actions.allEditingEvents()
    }
    
    func setApplicationReserved(_ action: @escaping () -> ()) {
        Actions.applicationReserved = action
        addTarget(self, action: #selector(applicationReserved), for: .applicationReserved)
    }
    
    @objc private func applicationReserved() {
        Actions.applicationReserved()
    }
    
    func setSystemReserved(_ action: @escaping () -> ()) {
        Actions.systemReserved = action
        addTarget(self, action: #selector(systemReserved), for: .systemReserved)
    }
    
    @objc private func systemReserved() {
        Actions.systemReserved()
    }
    
    func setAllEvents(_ action: @escaping () -> ()) {
        Actions.allEvents = action
        addTarget(self, action: #selector(allEvents), for: .allEvents)
    }
    
    @objc private func allEvents() {
        Actions.allEvents()
    }
    
}
