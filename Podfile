# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Libral Traders' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'SwiftKeychainWrapper'
  pod 'ImageCropper'
  pod 'QRCodeReader.swift'
  pod 'RealmSwift',  git: 'https://github.com/realm/realm-swift.git', commit: 'cedc1c8b0b2ab8506dd15703c36f8c0660774b18'
  
  pod 'SwiftyJSON', :inhibit_warnings => true
  pod 'Alamofire','~>4.9.1', :inhibit_warnings => true
  pod 'SwiftMessages', :inhibit_warnings => true
  pod 'Kingfisher', '~> 5.15.7'
  pod 'Reusable', :inhibit_warnings => true
  pod 'ActionSheetPicker-3.0', :inhibit_warnings => true
  pod 'MaterialComponents', :inhibit_warnings => true
  pod 'MDFInternationalization','~>2.0'
  pod 'Firebase/Core', :inhibit_warnings => true
  #pod 'Firebase/Crash', :inhibit_warnings => true
  pod 'Fabric', :inhibit_warnings => true
  #pod 'Crashlytics', :inhibit_warnings => true
  pod 'Firebase/Performance', :inhibit_warnings => true
  pod 'IQKeyboardManager', :inhibit_warnings => true
  pod 'Cosmos', :inhibit_warnings => true
  pod 'SVProgressHUD', :inhibit_warnings => true
  pod 'RSSelectionMenu'
  pod 'Firebase/MLVision', :inhibit_warnings => true
  pod 'Firebase/MLVisionLabelModel', :inhibit_warnings => true
  pod 'Firebase/MLVisionTextModel', :inhibit_warnings => true
  pod 'lottie-ios', :inhibit_warnings => true
  pod 'Firebase/Messaging', :inhibit_warnings => true
  pod 'TagListView', :inhibit_warnings => true
  pod 'Fabric', :inhibit_warnings => true
  #pod 'Crashlytics', :inhibit_warnings => true
  pod 'Siren', :inhibit_warnings => true
  pod 'JSQMessagesViewController', :inhibit_warnings => true
  pod 'Firebase/Database', :inhibit_warnings => true
  pod 'GooglePlacePicker', :inhibit_warnings => true
  pod 'RichEditorView', :git => 'https://github.com/T-Pro/RichEditorView.git', :branch => 'master'
  pod 'R.swift'
  pod 'OpenCV','3.4.2'
  pod 'Firebase'
  pod 'razorpay-pod'
  pod 'ZendeskChatSDK', :inhibit_warnings => true
  pod 'ZDCChat'
  pod 'BottomPopup'
  pod 'iOSDropDown'
  # Pods for Libral Traders

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end


#post_install do |installer|
#
#   installer.pods_project.targets.each do |target|
#
#    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle”
#
#     target.build_configurations.each do |config|
#
#       config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
#       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
#
#       end
#
#    end
#
#  end
#
#end
