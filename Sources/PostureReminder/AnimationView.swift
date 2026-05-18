import SwiftUI

func animationView(
    size: CGFloat = 132,
    repeats: Bool = true
) -> some View {
    AnimationView(size: size, repeats: repeats)
}

struct AnimationView: View {
    let size: CGFloat
    let repeats: Bool

    @State private var startDate = Date()

    private static let cycleDuration: TimeInterval = 4.13

    private static let outerBlack = Color(
        red: 0.035,
        green: 0.035,
        blue: 0.040
    )

    private static let innerGradient = Gradient(stops: [
        .init(color: Color(red: 0.96, green: 0.28, blue: 0.72), location: 0.00),
        .init(color: Color(red: 0.95, green: 0.31, blue: 0.66), location: 0.38),
        .init(color: Color(red: 1.00, green: 0.36, blue: 0.38), location: 0.70),
        .init(color: Color(red: 1.00, green: 0.56, blue: 0.18), location: 1.00)
    ])

    var body: some View {
        TimelineView(.animation) { timeline in
            animationCanvas(elapsed: timeline.date.timeIntervalSince(startDate))
        }
        .frame(width: size * 1.12, height: size * 2.55)
    }

    private func animationCanvas(elapsed: TimeInterval) -> Canvas<EmptyView> {
        let t = CGFloat(
            repeats
                ? elapsed.truncatingRemainder(dividingBy: Self.cycleDuration)
                : min(elapsed, Self.cycleDuration)
        )
        return Canvas { context, canvasSize in
            drawAnimation(in: CGRect(origin: .zero, size: canvasSize), context: context, t: t)
        }
    }

    private func drawAnimation(
        in rect: CGRect,
        context: GraphicsContext,
        t: CGFloat
    ) {
        let diameter = min(size, rect.width)
        let radius = diameter / 2.0

        let startCenterY = diameter * 1.69
        let endCenterY = diameter * 0.86
        let centerX = rect.midX

        let appear = springOut(smoothstep(0.68, 1.02, t))
        let ringReveal = min(1.05, springOut(smoothstep(1.04, 1.84, t)))

        let topTravel = smoothstep(1.94, 2.64, t)
        let bottomTravel = smoothstep(2.36, 3.06, t)

        let arrowProgress = smoothstep(1.86, 2.49, t)
        let innerCollapse = smoothstep(2.97, 3.77, t)
        let collapse = smoothstep(3.79, 4.13, t)

        let fadeIn = smoothstep(0.68, 0.78, t)
        let fadeOut = smoothstep(4.03, 4.13, t)

        let overallOpacity = fadeIn * (1.0 - fadeOut)

        guard overallOpacity > 0.001 else { return }

        let collapseScale = lerp(1.0, 0.055, easeInOutCubic(collapse))
        let globalScale = max(0.001, appear * collapseScale)

        let unscaledTop = lerp(startCenterY - radius, endCenterY - radius, topTravel)
        let unscaledBottom = lerp(startCenterY + radius, endCenterY + radius, bottomTravel)

        let scaleAnchorProgress = max(topTravel, bottomTravel)
        let scaleAnchorY = lerp(startCenterY, endCenterY, scaleAnchorProgress)

        let top = scaleAnchorY + (unscaledTop - scaleAnchorY) * globalScale
        let bottom = scaleAnchorY + (unscaledBottom - scaleAnchorY) * globalScale

        let outerWidth = diameter * globalScale
        let outerHeight = max(outerWidth, bottom - top)

        let outerRect = CGRect(
            x: centerX - outerWidth / 2.0,
            y: top,
            width: outerWidth,
            height: outerHeight
        )

        let outerPath = Path(
            roundedRect: outerRect,
            cornerSize: CGSize(width: outerWidth / 2.0, height: outerWidth / 2.0),
            style: .continuous
        )

        var outerContext = context
        outerContext.opacity = Double(overallOpacity)
        outerContext.fill(outerPath, with: .color(Self.outerBlack))

        let gradientOpacity = ringReveal
        let innerCollapseScale = lerp(1.0, 0.0, easeInOutCubic(innerCollapse))

        if gradientOpacity > 0.001 && innerCollapseScale > 0.001 {
            let innerBaseDiameter = diameter * 0.8
            let innerDiameter = innerBaseDiameter * ringReveal * globalScale * innerCollapseScale

            let unscaledInnerCenterY = unscaledTop + radius
            let innerCenterY = scaleAnchorY + (unscaledInnerCenterY - scaleAnchorY) * globalScale

            let innerRect = CGRect(
                x: centerX - innerDiameter / 2.0,
                y: innerCenterY - innerDiameter / 2.0,
                width: innerDiameter,
                height: innerDiameter
            )

            let innerPath = Path(ellipseIn: innerRect)

            var innerContext = context
            innerContext.opacity = Double(overallOpacity * gradientOpacity)

            innerContext.fill(
                innerPath,
                with: .linearGradient(
                    Self.innerGradient,
                    startPoint: CGPoint(x: innerRect.minX, y: innerRect.maxY),
                    endPoint: CGPoint(x: innerRect.maxX, y: innerRect.minY)
                )
            )

            var highlightContext = context
            highlightContext.opacity = Double(overallOpacity * gradientOpacity * 0.45)

            highlightContext.fill(
                innerPath,
                with: .radialGradient(
                    Gradient(colors: [
                        Color(red: 1.0, green: 0.58, blue: 0.18).opacity(0.85),
                        Color(red: 1.0, green: 0.58, blue: 0.18).opacity(0.0)
                    ]),
                    center: CGPoint(
                        x: innerRect.maxX - innerDiameter * 0.22,
                        y: innerRect.minY + innerDiameter * 0.22
                    ),
                    startRadius: 0,
                    endRadius: innerDiameter * 0.85
                )
            )

            let iconPath = uploadIconPath(
                center: CGPoint(x: centerX, y: innerCenterY + innerDiameter * 0.02),
                diameter: innerDiameter,
                progress: arrowProgress
            )

            var iconContext = context
            iconContext.opacity = Double(overallOpacity * gradientOpacity)

            iconContext.stroke(
                iconPath,
                with: .color(Self.outerBlack),
                style: StrokeStyle(
                    lineWidth: max(1.0, innerDiameter * 0.082),
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
    }

    private func uploadIconPath(
        center: CGPoint,
        diameter: CGFloat,
        progress: CGFloat
    ) -> Path {
        let p = clamp01(progress)
        let s = diameter * 0.48

        let tipY = lerp(center.y - s * 0.16, center.y - s * 0.43, p)
        let wingY = lerp(center.y + s * 0.13, center.y - s * 0.05, p)
        let wingX = lerp(s * 0.24, s * 0.27, p)

        let tip = CGPoint(x: center.x, y: tipY)
        let left = CGPoint(x: center.x - wingX, y: wingY)
        let right = CGPoint(x: center.x + wingX, y: wingY)

        var path = Path()
        path.move(to: left)
        path.addLine(to: tip)
        path.addLine(to: right)

        if p > 0.001 {
            let fullStemBottomY = center.y + s * 0.42
            let stemBottomY = lerp(tipY, fullStemBottomY, p)
            path.move(to: tip)
            path.addLine(to: CGPoint(x: center.x, y: stemBottomY))
        }

        return path
    }

    private func smoothstep(_ edge0: CGFloat, _ edge1: CGFloat, _ x: CGFloat) -> CGFloat {
        let p = clamp01((x - edge0) / (edge1 - edge0))
        return p * p * (3.0 - 2.0 * p)
    }

    private func springOut(_ x: CGFloat) -> CGFloat {
        let p = clamp01(x)
        let c1: CGFloat = 1.55
        let c3: CGFloat = c1 + 1.0
        let u = p - 1.0
        return min(1.06, max(0.0, 1.0 + c3 * u * u * u + c1 * u * u))
    }

    private func easeInOutCubic(_ x: CGFloat) -> CGFloat {
        let p = clamp01(x)
        if p < 0.5 {
            return 4.0 * p * p * p
        } else {
            let f = -2.0 * p + 2.0
            return 1.0 - (f * f * f) / 2.0
        }
    }

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * clamp01(t)
    }

    private func clamp01(_ x: CGFloat) -> CGFloat {
        min(1.0, max(0.0, x))
    }
}
