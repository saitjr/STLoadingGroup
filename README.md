# STLoadingGroup

A Group of Loading Animations.

![](./resources/loading.gif)

## Usage

```swift
let loadingGroup = STLoadingGroup(side: 100, style: .arch, config: STLoadingConfig(lineWidth: 8, animationDuration: 1.0))
loadingGroup.show(inView: view)
loadingGroup.startLoading()
// stop:  loadnigGroup.stopLoading()
```

#### Custom

If you want to add your own loading:

​	1\.Comfirm `STLoadingable` protocol and implement required functions (there is a `isLoading` property left)

```swift
protocol STLoadingable {
    var isLoading: Bool {get}
    
    func startLoading()
    func stopLoading()
}
```

​	2\.Append your loading style to `STLoadingStyle` in `STLoadingGroup.swift` file

```swift
enum STLoadingStyle: String {
    case submit = "submit"
    case glasses = "glasses"
    case walk = "walk"
    case arch = "arch"
    case bouncyPreloader = "bouncyPreloader"
    case zhihu = "zhihu"
}
```

​	3\.Add initializer for your loading: `case .yourStyle:` in  `STLoadingGroup`

```swift
class STLoadingGroup {
    fileprivate let loadingView: STLoadingable
    fileprivate let config: STLoadingConfig
    
    init(side: CGFloat, style: STLoadingStyle, config: STLoadingConfig = STLoadingConfig()) {
        self.config = config
        
        let bounds = CGRect(origin: .zero, size: CGSize(width: side, height: side))
        switch style {
        case .submit:
            loadingView = STSubmitLoading(frame: bounds, config: self.config)
        case .glasses:
            loadingView = STGlassesLoading(frame: bounds, config: self.config)
        case .walk:
            loadingView = STWalkLoading(frame: bounds, config: self.config)
        case .arch:
            loadingView = STArchLoading(frame: bounds, config: self.config)
        case .bouncyPreloader:
            loadingView = STBouncyPreloaderLoading(frame: bounds, config: self.config)
        case .zhihu:
            loadingView = STZhiHuLoading(frame: bounds, config: self.config)
        // add your code here...
        }
    }
}
```

## .glasses

**Designed by** : [bingbing](https://dribbble.com/bingbing). **Dribbble link** : [click me !](https://dribbble.com/shots/2124921-togic-loading)

## .walk

**Designed by** : [sandeep virk](https://dribbble.com/sandeepvirk87). **Dribbble link** : [click me !](https://dribbble.com/shots/2341109-Loading)

## .arch

**Designed by** : [John LaPrime](https://dribbble.com/johnlaprime). **Dribbble link** : [click me !](https://dribbble.com/shots/2392622-Loading-Animation)

## .bouncyPreloader

**Designed by** :  [Joash Berkeley](https://dribbble.com/JoashBerkeley). **Dribbble link** : [click me !](https://dribbble.com/shots/2391053-Bouncy-Preloader)

## .submit

Loading animation in submit button.

## .zhiHu

**Designed by** : ZhiHu daily.

## MIT LICENSE

``` 

The MIT License (MIT)

Copyright (c) 2016 saitjr

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```