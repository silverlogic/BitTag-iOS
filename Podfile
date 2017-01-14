# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'BitTag' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BitTag
  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'
  pod 'RestKit', '~> 0.27'

  target 'BitTagTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  # avoids issues with objc_msgSend
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = "NO"
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

end
