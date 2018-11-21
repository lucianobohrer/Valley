# Valley, a file downloader written in Swift 4 for iOS

<p align="center">
<img src="https://img.shields.io/cocoapods/v/Valley.svg?label=version">
<img src="https://img.shields.io/badge/platforms-iOS-lightgrey.svg">
<a href="https://travis-ci.org/lucianobohrer/Valley"><img src="https://travis-ci.org/lucianobohrer/Valley.svg?branch=master"></a>
</p>

* Images are downloaded asynchronously.
* [LRU](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU)) concept to cache management
* Allows to configure cache size.
* Has extension for UIImageView
* Provides closure properties manipulation and error handling.

# TODO List
- [x] In Memory Cache
- [ ] Disk Storage Cache
- [x] Improve cache item size
- [ ] New extensions (e.g. WKWebView)
- [x] Travis integration
## Setup

#### Setup with CocoaPods (iOS 10+)

If you are using CocoaPods add this text to your Podfile and run `pod install`.

```
use_frameworks!
target 'Your target name'
pod 'Valley'
```
## Usage

1. Add `import Valley` to your code

2. From your UIImageView instance, you can just:
```Swift
imageView.valleyImage(url: "https://yourwebseite.com/img.jpeg")
```
3. To download other kind of files for example:
```Swift
// JSON
ValleyFile<[[String: Any]]>.request(url: "https://yourwebsite.com/data.json") { (json) in }

// Data to fill a webview with a PDF
ValleyFile<Data>.request(url: "https://yourwebsite.com/myfile.pdf") { (data) in }
```
## Canceling download

To manually cancel the download, call:
```Swift
let task = imageView.valleyImage(url: "https://yourwebseite.com/img.jpeg")
task.cancel()
```


## Supply a placeholder image

You can supply an error image that will be used if an error occurs during image download.

```Swift
imageView.valleyImage(url: "https://yourwebseite.com/img.jpeg", placeholder: image)
```

## Cache
The following method clear all items from cache

```Swift
Valley.cache.clearCache()
```

## Settings

Use `Valley.setup(capacity: Int)` to define a capacity in bytes to cache.

## Demo app

The demo iOS app shows how to load images in a collection view with Valley and also load files like JSON.

## Alternative solutions

Here is the list of other image download libraries for Swift.

* [cbot/Vincent](https://github.com/cbot/Vincent)
* [daltoniam/Skeets](https://github.com/daltoniam/Skeets)
* [Haneke/HanekeSwift](https://github.com/Haneke/HanekeSwift)
* [hirohisa/ImageLoaderSwift](https://github.com/hirohisa/ImageLoaderSwift)
* [natelyman/SwiftImageLoader](https://github.com/natelyman/SwiftImageLoader)
* [onevcat/Kingfisher](https://github.com/onevcat/Kingfisher)
* [zalando/MapleBacon](https://github.com/zalando/MapleBacon)
* [evgenyneu/moa](https://github.com/evgenyneu/moa/)
* [kean/Nuke](https://github.com/kean/Nuke)

## License

Valley is released under the [MIT License](LICENSE).

## Feedback is welcome

If you notice any issue, got stuck or just want to chat feel free to create an issue. I will be happy to help you.

## •ᴥ•
