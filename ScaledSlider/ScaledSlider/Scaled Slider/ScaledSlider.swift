//
//  ScaledSlider.swift
//  ScaledSlider
//
//  Created by Zhi Zhou on 2023/3/24.
//

import UIKit

@available(iOS 14.0, *)
open class ScaledSlider: UIView {

    private let slider = UISlider()

    open var isEnabled: Bool = true {
        didSet {
            slider.isUserInteractionEnabled = isEnabled
            trackColor = isEnabled ? UIColor.systemGray : UIColor.systemGray.withAlphaComponent(0.3)
            
            setNeedsDisplay()
        }
    }
    
    /// 刻度值合集。
    open var scales: [Float] = [] {
        didSet {
            loadScales()
            setNeedsDisplay()
        }
    }
    
    /// 滑动条的当前值。
    open var value: Float {
        get {
            let index = lroundf(slider.value * Float(numberOfScales - 1))
            
            return scales[index]
        }
        
        set {
            let index = scales.firstIndex(of: newValue) ?? 0
            slider.value = _scales[index]

            setNeedsDisplay()
        }
    }
    
    /// 刻度数量。
    open var numberOfScales: Int {
        return scales.count
    }
    
    open override var tintColor: UIColor! {
        didSet {
            trackColor = tintColor
        }
    }
    
    /// 滑轨颜色。
    open var trackColor = UIColor.systemGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 刻度高度。
    open var scaleHeight: CGFloat = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 滑轨粗细。
    open var trackLineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var minimumValueImage: UIImage? {
        didSet {
            slider.minimumValueImage = minimumValueImage // e.g.: UIImage(systemName: "textformat.size.smaller")
        }
    }

    open var maximumValueImage: UIImage? {
        didSet {
            slider.maximumValueImage = maximumValueImage // e.g.: UIImage(systemName: "textformat.size.larger")
        }
    }
    
    
    private var _scales: [Float] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var previousIndex: Int = -1
    
    public let valueDidChangeHandler = Delegate<(index: Int, currentValue: Any), Void>()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupInterface()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(trackColor.cgColor)
        context?.setLineWidth(trackLineWidth)
        context?.beginPath()
                
        // 原有轨迹位置与尺寸。
        let trackRect = slider.trackRect(forBounds: slider.frame)
        
        // 计算出原有轨迹的垂直居中位置。
        let centerY = trackRect.origin.y + trackRect.height / 2
        
        // 绘制新的轨迹。
        context?.move(to: CGPoint(x: sliderThumbCenter(slider, value: _scales.first!), y: centerY))
        context?.addLine(to: CGPoint(x: sliderThumbCenter(slider, value: _scales.last!), y: centerY))
        
        let scaleTop = centerY - scaleHeight / 2
        let scaleBottom = centerY + scaleHeight / 2

        // 绘制刻度。
        (0..<numberOfScales).forEach { (value) in
            let scaleX = sliderThumbCenter(slider, value: _scales[value])

            context?.move(to: CGPoint(x: scaleX, y: scaleTop))
            context?.addLine(to: CGPoint(x: scaleX, y: scaleBottom))
        }

        context?.strokePath()
    }
    
}

extension ScaledSlider {
    
    private func setupInterface() {
        
        backgroundColor = .clear
        
        // 旋转屏幕时可以重新绘制刻度线。
        contentMode = .redraw
        
        setupSlider()
        setupGestureRecognizer()
    }
    
    private func setupSlider() {
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            slider.topAnchor.constraint(equalTo: self.topAnchor),
            slider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        loadScales()
    }
    
}

extension ScaledSlider {
    
    private func setupGestureRecognizer() {
        // 设定滑块点击事件。点击事件触发时，滑块自动滑动到相应的点击位置。
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
        slider.addGestureRecognizer(tapGR)
    }
    
    private func loadScales() {
        
        let scalePoint = slider.maximumValue / Float(scales.count - 1)
        
        _scales = (0..<scales.count).compactMap({ Float($0) * scalePoint })
    }
    
}

extension ScaledSlider {
    
    private func sliderThumbCenter(_ slider: UISlider, value: Float) -> CGFloat {
        // 原有 slider 轨道的坐标与尺寸。
        let trackRect = slider.trackRect(forBounds: slider.frame)
        
        // 滑块的坐标与尺寸。
        let thumbRect = slider.thumbRect(forBounds: slider.frame, trackRect: trackRect, value: value)
                
        return thumbRect.midX
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        
        let index = lroundf(sender.value * Float(numberOfScales - 1))

        setSliderIndex(index, animated: false)
    }
    
    @objc private func sliderTapped(_ gr: UITapGestureRecognizer) {
        
        // 当前点击的位置
        let currentPoint = gr.location(in: self)
        
        // 滑块的起始点
        let startPointX = sliderThumbCenter(slider, value: _scales.first!)
        // 滑块的终止点
        let endPointX = sliderThumbCenter(slider, value: _scales.last!)
        
        // 滑块的总长
        let thumbWidth = endPointX - startPointX
        
        // 当前点击位置在滑块上的真实坐标
        let thumbPoint = currentPoint.x - startPointX
        
        let value = thumbPoint / thumbWidth
        
        let index = lroundf(Float(value) * Float(numberOfScales - 1))
        
        let safeIndex = index < 0 ? 0 : (index > _scales.count - 1 ? _scales.count - 1 : index)

        setSliderIndex(safeIndex, animated: true)
    }
    
    // 设定滑块的位置
    private func setSliderIndex(_ index: Int, animated: Bool) {
        
        slider.setValue(_scales[index], animated: animated)
        
        guard previousIndex != index else { return }
        
        let currentValue = scales[index]
        
        valueDidChangeHandler((index, currentValue))

        HapticFeedback.Impact.light()

        previousIndex = index
    }
    
}































