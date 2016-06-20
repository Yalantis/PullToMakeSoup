
##PullToMakeSoup [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Custom animated pull-to-refresh that can be easily added to UIScrollView

[![Yalantis](https://raw.githubusercontent.com/Yalantis/PullToMakeSoup/master/PullToMakeSoupDemo/Resouces/badge_dark.png)](https://yalantis.com/?utm_source=github)

Check this [article on our blog](https://yalantis.com/blog/how-we-built-customizable-pull-to-refresh-pull-to-cook-soup-animation/?utm_source=github) to know more details about animations implementation

Inspired by [this project on dribble](https://dribbble.com/shots/2074667-Recipe-Finder-v-2)

<img src="https://raw.githubusercontent.com/Yalantis/PullToMakeSoup/master/PullToMakeSoupDemo/Resouces/recipe-finder.gif" />

##Requirements
- iOS 8.0+
- Xcode 7
- Swift 2

####[Carthage](https://github.com/Carthage/Carthage)
```
github "Yalantis/PullToMakeSoup" "master"
```

##Installing with [CocoaPods](https://cocoapods.org)

```ruby
use_frameworks!
pod 'PullToMakeSoup', '~> 1.2'
```

##Usage

At first, import PullToMakeSoup framework:

```swift
import PullToMakeSoup
```

Create refresher:


```swift
let refresher = PullToMakeSoup()
```

Add refresher to your UIScrollView subclass in 'viewDidAppear' method and provide action block:

```swift

override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    tableView.addPullToRefresh(refresher, action: {
        // action to be performed (pull data from some source)
    })
}

```

After the action is completed and you want to hide the refresher:

```swift
tableView.endRefreshing()
```
 
You can also start refreshing programmatically:

```swift
tableView.startRefreshing()
```

Component was implemented based on [customizable pull-to-refresh](https://github.com/Yalantis/PullToRefresh)

## Let us know!

We’d be really happy if you sent us links to your projects where you use our component. Just send an email to github@yalantis.com And do let us know if you have any questions or suggestion regarding the animation. 

P.S. We’re going to publish more awesomeness wrapped in code and a tutorial on how to make UI for iOS (Android) better than better. Stay tuned!


## License

	The MIT License (MIT)

	Copyright © 2015 Yalantis

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
