 
 import UIKit
 import SwiftyStoreKit
 import StoreKit
 import ProgressHUD
 class SubscriptionVc: UIViewController,UIScrollViewDelegate {
     
     @IBOutlet weak var yealryLabel: UILabel!
     
     @IBOutlet weak var weeklyLabel: UILabel!
     @IBOutlet weak var roundedView: UIView!
    @IBOutlet var trialButton: UILabel!
     @IBOutlet var leadingSpaceForButton: NSLayoutConstraint!
     @IBOutlet var privacyPolicy: UIButton!
     @IBOutlet var heightConstrainForView: NSLayoutConstraint!
     
     @IBOutlet var topView: UIView!
     @IBOutlet var topScrollView: UIScrollView!
     
     @IBOutlet var view1: UIImageView!
     @IBOutlet var view2: UIImageView!
     
     @IBOutlet weak var monthlyLable: UILabel!
     override func viewDidLoad() {
         super.viewDidLoad()
         topScrollView.delegate = self
        roundedView.layer.cornerRadius = 20.0
        roundedView.clipsToBounds = true
         // Do any additional setup after loading the view.
     }
     
     
     
     @IBAction func gotoPreviousView(_ sender: Any) {
         ProgressHUD.dismiss()
         self.dismiss(animated: true, completion: nil)
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         let screenRect = UIScreen.main.bounds
         let screenWidth = screenRect.size.width
         let screenHeight = screenRect.size.height
         weeklyLabel.text = weeklyPrice
         monthlyLable.text = monthlyPrice
         yealryLabel.text = yearlyPrice
         self.retriveProduct()
         weeklyLabel.text = weeklyPrice
         monthlyLable.text = monthlyPrice
         yealryLabel.text = yearlyPrice
         
         
     }
     
     func retriveProduct()  {
         SwiftyStoreKit.retrieveProductsInfo([PoohWisdomProducts.yearlySub,PoohWisdomProducts.weeklySub,PoohWisdomProducts.monthlySub]) { result in
             result.retrievedProducts.forEach { product in
                 
                
                 if product.productIdentifier.elementsEqual(PoohWisdomProducts.weeklySub){
                    weeklyPrice =  "\(product.localizedPrice ?? "$3.99")/Week"
                     
                 }
                 else if product.productIdentifier.elementsEqual(PoohWisdomProducts.monthlySub){
                     monthlyPrice =  "\(product.localizedPrice ?? "$10.99")/Month"
                     
                 }
                 
                 else if product.productIdentifier.elementsEqual(PoohWisdomProducts.yearlySub){
                     
                     if let tril = product.introductoryPrice?.localizedSubscriptionPeriod{
                         let day = tril.replacingOccurrences(of: " ", with: "-")
                         var mama  = "Try \(day) for free, then "
                         var kikos =  "\(product.localizedPrice ?? "$28.99")/Year"
                         yearlyPrice = mama + kikos
                         
                         
                         
                     }else{
                         
                     }
                     
                     
                 }
                 
                 self.weeklyLabel.text = weeklyPrice
                 self.monthlyLable.text = monthlyPrice
                 self.yealryLabel.text = yearlyPrice
             }
         }
     }
     
     
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         
         var width = (self.view.frame.size.width - trialButton.frame.size.width) / 4.0
         
         leadingSpaceForButton.constant =  width
         
         
         heightConstrainForView.constant = privacyPolicy.frame.origin.y + privacyPolicy.frame.size.height + 50
         self.setViewSettingWithBgShade(view: topView)
         
         view1.layer.cornerRadius = 20
        // view1.layer.borderWidth = 1
         //view1.layer.borderColor = UIColor(red: 135.0/255.0, green: 14.0/255.0, blue: 79.0/255.0, alpha: 1.0).cgColor
         
         view2.layer.cornerRadius = 20
         //view2.layer.borderWidth = 1
         //view2.layer.borderColor = UIColor(red: 135.0/255.0, green:14.0/255.0, blue: 79.0/255.0, alpha: 1.0).cgColor
         topScrollView.setContentOffset(CGPoint(x:0, y: 0), animated: false)
         
     }
     
     
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
     {
         print(topScrollView.contentOffset.y)
         if(topScrollView.contentOffset.y<=44)
         {
             topScrollView.setContentOffset(CGPoint(x:0, y: 0), animated: true)
         }
     }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         
         
         
     }
     public func setViewSettingWithBgShade(view: UIView)
     {
       // view.backgroundColor = UIColor.red
         
        // view.layer.shadowOpacity = 0.5
         //view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        // view.layer.shadowRadius = 3.0
         //view.layer.shadowColor = UIColor.black.cgColor
        // view.layer.masksToBounds = false
     }
     
     
     @IBAction func gotoTermPolicy(_ sender: Any) {
         self.gotoWebView(name: "Terms of Use", url: Store.sharedInstance.termsOfUseValue)
         
         
     }
     func buyAproduct(value:String)
     {
         SwiftyStoreKit.purchaseProduct(value, quantity: 1, atomically: false) { result in
             switch result {
             case .success(let product):
                 // fetch content from your server, then:
                 if product.needsFinishTransaction {
                     Store.sharedInstance.setPurchaseActive(value: true)
                     Store.sharedInstance.verifyReciept()
                     ProgressHUD.dismiss()
                     SwiftyStoreKit.finishTransaction(product.transaction)
                 }
                 print("Purchase Success: \(product.productId)")
             case .error(let error):
                 switch error.code {
                 case .unknown: ProgressHUD.dismiss()
                 case .clientInvalid: ProgressHUD.dismiss()
                 case .paymentCancelled:  ProgressHUD.dismiss()
                 case .paymentInvalid: ProgressHUD.dismiss()
                 case .paymentNotAllowed:  ProgressHUD.dismiss()
                 case .storeProductNotAvailable:ProgressHUD.dismiss()
                 case .cloudServicePermissionDenied: ProgressHUD.dismiss()
                 case .cloudServiceNetworkConnectionFailed: ProgressHUD.dismiss()
                 case .cloudServiceRevoked: ProgressHUD.dismiss()
                 default: print((error as NSError).localizedDescription)
                 }
             }
         }
     }
     @IBAction func gotoPrivacyPolcy(_ sender: Any) {
         self.gotoWebView(name: "Privacy Policy", url:  Store.sharedInstance.privacyPolicyValue)
         
     }
     func gotoWebView(name:String,url:String)
     {
         let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CommonViewController") as? CommonViewController
         vc?.titleForValue = name
         vc?.url = url
         let navController = UINavigationController(rootViewController: vc!) // Creating a navigation controller with VC1 at the root of the navigation stack.
         
         navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         present(navController, animated: true, completion: nil)
     }
     @IBAction func restorePurchaseItem(_ sender: Any) {
         
         if ( UIDevice.current.model.range(of: "iPad") != nil){
                    self.perform(#selector(self.targetMethod), with: self, afterDelay: 0.5)
                }
         
         ProgressHUD.show()
         
         SwiftyStoreKit.restorePurchases(atomically: true) { results in
             if results.restoreFailedPurchases.count > 0 {
                 ProgressHUD.dismiss()
             }
             else if results.restoredPurchases.count > 0 {
                 
                 Store.sharedInstance.setPurchaseActive(value: true)
                 Store.sharedInstance.verifyReciept()
                 ProgressHUD.dismiss()
                 
                 let alert = UIAlertController(title: "", message: "Restore purchase done", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                 
             }
             else {
                 
                 let alert = UIAlertController(title: "", message: "Nothing to restore", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                 ProgressHUD.dismiss()
             }
         }
        
         
     }
     @IBAction func btn1Pressed(_ sender: Any) {
         self.purchaseItemIndex(index: 0)
     }
     
     @IBAction func btn2Pressed(_ sender: Any) {
         self.purchaseItemIndex(index: 1)
     }
     
     @IBAction func btn3Pressed(_ sender: Any) {
         self.purchaseItemIndex(index: 2)
     }
     @objc fileprivate func targetMethod(){
           ProgressHUD.dismiss()
     }
     
     private func purchaseItemIndex(index: Int) {
          if ( UIDevice.current.model.range(of: "iPad") != nil){
             self.perform(#selector(self.targetMethod), with: self, afterDelay: 0.5)
         }
         DispatchQueue.main.async{
            ProgressHUD.show("Purchasing ... ")

         }
         
         var productId =
             [PoohWisdomProducts.yearlySub, PoohWisdomProducts.weeklySub,PoohWisdomProducts.monthlySub]
         
         self.buyAproduct(value: productId[index])
         
         return
             
             Store.sharedInstance.setCurrentItem(value: productId[index])
         PoohWisdomProducts.store.requestProducts { [weak self] success, products in
             guard let self = self else { return }
             guard success else {
                 
                 DispatchQueue.main.async {
                     
                     //ERProgressHud.sharedInstance.hide()
                     let alertController = UIAlertController(title: "Failed to load list of products",
                                                             message: "Check logs for details",
                                                             preferredStyle: .alert)
                     alertController.addAction(UIAlertAction(title: "OK", style: .default))
                     
                 }
                 
                 
                 return
             }
             PoohWisdomProducts.store.buyProduct(products![0] as SKProduct) { [weak self] success, productId in
                 guard let self = self else {
                     
                    // return
                     
                 }
                 guard success else {
                     
                     return
                 }
                 
             }
         }
         
     }
     
     
 }


