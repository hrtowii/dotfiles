import "root:/services"
import Qt5Compat.GraphicalEffects

DropShadow {
    anchors.fill: source
    color: Qt.alpha(Colours.palette.m3shadow, 0.7)
    radius: 10
    samples: 1 + radius * 2
}
