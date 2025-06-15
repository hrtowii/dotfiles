import "root:/config"

StyledText {
    property real fill

    font.family: Appearance.font.family.material
    font.pointSize: Appearance.font.size.larger
    font.variableAxes: ({
            FILL: fill.toFixed(1)
        })
}
