Pod::Spec.new do |s|

  s.name         = "PullToRefresher"
  s.version      = "1.3.1"
  s.summary      = "This component implements pure pull-to-refresh logic and you can use it for developing your own pull-to-refresh animations"

  s.homepage     = "http://yalantis.com/blog/how-we-built-customizable-pull-to-refresh-pull-to-cook-soup-animation/"


  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = "Yalantis"
  s.social_media_url   = "https://twitter.com/yalantis"

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"


  s.source       = { :git => "https://github.com/Yalantis/PullToRefresh.git", :tag => s.version.to_s }
  s.source_files = "PullToRefresh/*.swift"
  s.module_name  = "PullToRefresh"
  s.requires_arc = true

end
