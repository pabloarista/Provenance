//
//  NintendoGatekeeper.swift
//  PVSupport
//
//  Created by Pablo Arista on 4/24/25.
//

@MainActor
private var n64GamepadKey: UInt8 = 0

public extension GCController {
    // This is a static block that will execute only once, when GCController is first accessed
    static let swizzleExtendedGamepad: Void = {
        let originalSelector = #selector(getter: GCController.extendedGamepad)
        let swizzledSelector = #selector(swizzled_extendedGamepad)

        if let originalMethod = class_getInstanceMethod(GCController.self, originalSelector),
           let swizzledMethod = class_getInstanceMethod(GCController.self, swizzledSelector) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()

    // will try to find the correct NSO controller and if not just return the current controller.
    @objc
    @MainActor
    func swizzled_extendedGamepad() -> GCExtendedGamepad? {
        let originalExtendedGamepad = swizzled_extendedGamepad()  // Calls original due to swizzling

        guard productCategory == "Switch N64 Controller" else {
            return originalExtendedGamepad
        }
        
        // Try to fetch the cached Nintendo64SwitchGamepad
        if let cachedGamepad = objc_getAssociatedObject(self, &n64GamepadKey) as? Nintendo64SwitchGamepad {
            return cachedGamepad
        }
        
        // Create a new Nintendo64SwitchGamepad and cache it
        guard let n64Gamepad = Nintendo64SwitchGamepad(controller: self)
        else {
            return originalExtendedGamepad
        }
        objc_setAssociatedObject(self, &n64GamepadKey, n64Gamepad, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return n64Gamepad
    }

    // initiates swizzling to add nintendo switch controllers
    public static func initNintendoSwitchControllers() {
        _ = swizzleExtendedGamepad  // Ensure swizzling happens by referencing the static property
    }
}
