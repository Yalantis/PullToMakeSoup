# Customizable PullToRefresh

This component implements pure pull-to-refresh logic and you can use it for developing your own pull-to-refresh animations, [like this one.](https://github.com/Yalantis/PullToMakeSoup)

[![Yalantis](https://raw.githubusercontent.com/Yalantis/PullToRefresh/develop/PullToRefreshDemo/Resources/badge_dark.png)](https://yalantis.com/?utm_source=github)

##Requirements
- iOS 8.0+
- Xcode 7
- Swift 2

##Installing with [CocoaPods](https://cocoapods.org)

```ruby
use_frameworks!
pod 'PullToRefresher', '~> 1.0'
```

##Usage

At first, import PullToRefresh:

```swift
import PullToRefresh
```

The easiest way to create *PullToRefresh*:

```swift
let refresher = PullToRefresh()
```

It will create a default pull-to-refresh with a simple view which has single *UIActivitiIndicatorView*. To add refresher to your *UIScrollView* subclass:

```swift
tableView.addPullToRefresh(refresher, action: {
    // action to be performed (pull data from some source)
})
```

After the action is completed and you want to hide the refresher:

```swift
tableView.endRefreshing()
```

You can also start refreshing programmatically:

```swift
tableView.startRefreshing()
```

But you probably won’t use this component, though. *UITableViewController* and *UICollectionViewController* already have a simple type of refresher.
It’s much more interesting to develop your own pull-to-refresh control.

##Creating custom PullToRefresh

To create a custom refresher you would need to initialize *PullToRefresh* class with two objects:

- **refreshView** is a UIView object which will added to your scroll view;
- **animator** is an object which will animate elements on refreshView depending on the state of PullToRefresh.

```swift
let awesomeRefrehser = PullToRefresh(refresherView: yourView, animator: yourAnimator)
```
###Steps for creating custom PullToRefresh

1) Create a custom *UIView* with *.xib and add all images that you want to animate as subviews. Pin them with outlets:

```swift
class RefreshView: UIView {
    @IBOutlet
    private var imageView: UIImageView!
  
    // and others
}
```

2) Create an *Animator* object that conforms *RefreshViewAnimator* protocol and can be initialized by your custom view:

```swift
class Animator: RefreshViewAnimator {
    private let refreshView: RefreshView
    
    init(refreshView: RefreshView) {
        self.refreshView = refreshView
    }

    func animateState(state: State) {
        // animate refreshView according to state
    }
}
```

3) According to RefreshViewAnimator protocol, your animator should implement *animateState* method. This method is get called by *PullToRefresh* object every time its state is changed. There are four states:

```swift
enum State:Equatable {
    case Inital, Loading, Finished
    case Releasing(progress: double)
}
```

- **Initial** - refresher is ready to be pulled.
- **Releasing** - refresher is in the process of releasing (by a user or programmatically). This state contains a double value which represents releasing progress from 0 to 1.
- **Loading** - refresher is in the loading state.
- **Finished** - loading is finished.

Depending on the state that your animator gets from the *PullToRefresh*, it has to animate elements in *refreshView*:

```swift
func animateState(state: State) {
    switch state {
      case .Inital: // do inital layout for elements
      case .Releasing(let progress): // animate elements according to progress
      case .Loading: // start loading animations
      case .Finished: // show some finished state if needed
    }
}
```

Place the magic of animations insted of commented lines.

4) For the convitience sake you can sublass from *PullToRefresh* and create separate class for your refresher:

```swift
class AwesomePullToRefresh: PullToRefresh {
    convenience init() {
        let refreshView =  NSBundle.mainBundle().loadNibNamed("RefreshView", owner: nil, options: nil).first as! RefreshView
        let animator =  Animator(refreshView: refreshView)
        self.init(refreshView: refreshView, animator: animator)
    }
}
```

5) Finally, add a refresher to a UIScrollView subclass:

```swift
tableView.addPullToRefresh(refresher, action: {
    // action to be performed (pull data from some source)
})
```

Have fun! :)

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

