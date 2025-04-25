//
//  Nintendo64SwitchGamepad.swift
//  PVSupport
//
//  Created by Pablo Arista on 4/24/25.
//

/// Gamepad for the Nintendo Switch Online Nintendo 64 Controller. This is a proxy that tries to map the non mfi buttons to actual mfi buttons without having to hand code this for each core.
class Nintendo64SwitchGamepad: GCExtendedGamepad {
    weak open var internalController: GCController?
    //TODO: find this mapping
    var internalButtonHome: GCControllerButtonInput? = nil
    
    let internalButtonLeft: GCControllerButtonInput
    let internalButtonZ: GCControllerButtonInput
    let internalButtonRight: GCControllerButtonInput
    
    let internalButtonB: GCControllerButtonInput
    let internalButtonA: GCControllerButtonInput
    let internalButtonStart: GCControllerButtonInput
    
    //TODO: find this mapping
    var internalButtonShare: GCControllerButtonInput? = nil
    //TODO: find this mapping
    var internalButtonZR: GCControllerButtonInput? = nil
    
    let internalCbuttons: GCControllerDirectionPad
    
    let internalThumbstick: GCControllerDirectionPad
    
    let internalDpad: GCControllerDirectionPad
    
    override var controller: GCController? {
        internalController
    }
    
    override var leftShoulder: GCControllerButtonInput {
        internalButtonLeft
    }
    
    override var leftTrigger: GCControllerButtonInput {
        internalButtonZ
    }
    
    override var rightShoulder: GCControllerButtonInput {
        internalButtonRight
    }
    
    override var buttonB: GCControllerButtonInput {
        internalButtonB
    }
    
    override var buttonA: GCControllerButtonInput {
        internalButtonA
    }
    
    override var buttonMenu: GCControllerButtonInput {
        internalButtonStart
    }
    
    override var rightThumbstick: GCControllerDirectionPad {
        internalCbuttons
    }
    
    override var leftThumbstick: GCControllerDirectionPad {
        internalThumbstick
    }
    
    override var dpad: GCControllerDirectionPad {
        internalDpad
    }
    
    /// using `controller` to map correct buttons.
    /// - Parameter controller: actual controller to map non mfi buttons to the actual mfi buttons
    init?(controller: GCController) {
        let buttons: [String: GCControllerButtonInput]  = controller.physicalInputProfile.buttons
        let dpads: [String: GCControllerDirectionPad]   = controller.physicalInputProfile.dpads
        
        guard let buttonLeft        = buttons["Left Shoulder"],
                  let buttonZ       = buttons["Left Trigger"],
                  let buttonRight   = buttons["Right Shoulder"],
                  let buttonB       = buttons["Button B"],
                  let buttonA       = buttons["Button A"],
                  let buttonStart   = buttons["Button Menu"],
                  let cButtons      = dpads["Right Thumbstick"],
                  let thumbstick    = dpads["Left Thumbstick"],
                  let dpad          = dpads["Direction Pad"] else {
                return nil
            }
        internalButtonLeft  = buttonLeft
        internalButtonZ     = buttonZ
        internalButtonRight = buttonRight
        internalButtonB     = buttonB
        internalButtonA     = buttonA
        internalButtonStart = buttonStart
        internalCbuttons    = cButtons
        internalThumbstick  = thumbstick
        internalDpad        = dpad
        internalController  = controller
        super.init()
    }
}
