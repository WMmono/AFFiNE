import Foundation
import Capacitor

@objc(IntelligentsPlugin)
public class IntelligentsPlugin: CAPPlugin, CAPBridgedPlugin {
  public let identifier = "IntelligentsPlugin"
  public let jsName = "Intelligents"
  public let pluginMethods: [CAPPluginMethod] = [
    CAPPluginMethod(name: "presentIntelligentsButton", returnType: CAPPluginReturnPromise),
    CAPPluginMethod(name: "dismissIntelligentsButton", returnType: CAPPluginReturnPromise)
  ]
  public let ui: UIViewController
  
  init(ui: UIViewController) {
    self.ui = ui
    super.init()
  }
  
  @objc public func presentIntelligentsButton(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      self.ui.presentIntelligentsButton()
      print("!!!!!!!!!!!!present")
      call.resolve()
    }
  }
  
  @objc public func dismissIntelligentsButton(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      self.ui.dismissIntelligentsButton()
      print("!!!!!!!!!!!!dismiss")
      call.resolve()
    }
  }
}
