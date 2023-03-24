# ScaledSlider
带有刻度的 UISlider。
![WX20230324-185311@2x](https://user-images.githubusercontent.com/17865033/227502491-14271df5-4300-47b7-ae8c-c28b38eafee4.png)

* 实现像系统设置内的刻度 UISlider 一样的分段功能。
* 可以进行点击自动滑动到相应的位置。
* 横竖屏切换时会自动重新绘制滑轨。
* 可以自定义左右侧图片。

示例：
```swift
  slider.tintColor = .purple
  slider.scales = [10, 20, 30, 40, 50, 60]
  slider.minimumValueImage = UIImage(systemName: "textformat.size.smaller")
  slider.maximumValueImage =  UIImage(systemName: "textformat.size.larger")
  slider.startValue = 0
  slider.trackColor = .orange
        
  slider.valueDidChangeHandler.delegate(on: self) { (self, scaleIndex) in
    print(">>>>>>", scaleIndex)
  }
```
