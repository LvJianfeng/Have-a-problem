## 渐变图片创建

#### 色彩网站
分享->👇👇👇[传送门](http://encycolorpedia.com/)👇👇👇

#### 示例代码
```swift
func imageForColors(colors: Array<UIColor> = [], withFrame frame: CGRect) -> UIImage? {
    guard colors.count > 0 else {
        return nil
    }
    
    var cgArrayColor: Array<CGColor> = []
    for color in colors {
        cgArrayColor.append(color.cgColor)
    }
    UIGraphicsBeginImageContextWithOptions(frame.size, true, 1.0)
    let context = UIGraphicsGetCurrentContext()
    context?.saveGState()
    var colorSpace = (colors.last?.cgColor)!.colorSpace
    var gradient = CGGradient(colorsSpace: colorSpace, colors: cgArrayColor as CFArray, locations: nil)
    context?.drawLinearGradient(gradient!, start: CGPoint.init(x: 0.0, y: frame.size.height), end: CGPoint.init(x: frame.size.width, y: 0.0), options: .drawsBeforeStartLocation)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    gradient = nil
    context?.restoreGState()
    colorSpace = nil
    UIGraphicsEndImageContext()
    
    return image
}
```

#### 注意
以上内容为个人整理，如果有问题有出入或者你有更好的解决方法，还请赐教哦，感谢。


