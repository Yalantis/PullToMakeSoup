[![Yalantis](https://raw.githubusercontent.com/Yalantis/PullToMakeSoup/master/PullToMakeSoup/Recources/badge_grey.png)](https://yalantis.com)

##PullToMakeSoup

Custom animated pull-to-refresh that can be easily added to UIScrollView

Check [this project on dribble](https://dribbble.com/shots/2074667-Recipe-Finder-v-2)

<img src="https://raw.githubusercontent.com/Yalantis/PullToMakeSoup/master/PullToMakeSoup/Recources/recipe-finder.gif" />

##Usage


Create refresher:


```swift
let refresher = PullToMakeSoup()
```

Add refresher to your UIScrollView subclass and provide action block:

```swift
tableView.addPullToRefresh(refresher, action: {
     // action to be performed (pull data from some source)
})
```

After the action is completed and you want to hide the refresher:

```swift
tableView.endRefresing()
```
 
You can also start refreshing programmatically:

```swift
tableView.startRefreshing()
```

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
