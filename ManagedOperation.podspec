Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "ManagedOperation"
s.summary = "An NSOperation for easy async block operations"
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "jatoma" => "[jatoma@o2.pl]" }

s.homepage = "https://github.com/jatoma/ManagedOperation.git"


s.source = { :git => "https://github.com/jatoma/ManagedOperation.git", :tag => "#{s.version}"}

s.framework = "UIKit"

s.source_files = "ManagedOperation/**/*.{swift}"


end