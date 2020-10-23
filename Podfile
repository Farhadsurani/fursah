# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Fursahh' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'ReachabilitySwift'
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'AlamofireObjectMapper'
  pod 'SwiftyJSON'
  pod 'Hero'
  pod 'NVActivityIndicatorView'
  pod 'IQKeyboardManagerSwift'
  pod 'MaterialComponents'
  pod 'SideMenu'
  pod 'DropDown'
  pod 'ALCameraViewController'
  pod 'DLRadioButton'
  pod 'BBBadgeBarButtonItem'
  pod 'SwiftyCodeView'
  pod 'ImageSlideshow'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'FacebookSDK'
  pod 'SDWebImage'
  pod 'ESPullToRefresh'
  pod 'ImageSlideshow/Alamofire'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Crashlytics'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
  pod 'TagListView', :git => 'https://github.com/jomisj/TagListView.git'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end


