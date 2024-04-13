# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Dgtera Task' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!


  # Pods for Dgtera Task
  pod 'Alamofire'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage', '~> 5.11.1'
  pod 'RxSwift'
  pod 'RxCocoa'

  target 'Dgtera TaskTests' do
    inherit! :search_paths
    # Pods for testing
  pod 'Alamofire'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage', '~> 5.11.1'
  pod 'RxSwift'
  pod 'RxCocoa'
  end

  target 'Dgtera TaskUITests' do
    # Pods for testing
  end

end
post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
		end
	end
end
