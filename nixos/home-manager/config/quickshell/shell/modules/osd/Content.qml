import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick

Column {
    id: root

    required property Brightness.Monitor monitor

    padding: Appearance.padding.large

    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left

    spacing: Appearance.spacing.normal

    VerticalSlider {
        icon: {
            if (Audio.muted)
                return "no_sound";
            if (value >= 0.5)
                return "volume_up";
            if (value > 0)
                return "volume_down";
            return "volume_mute";
        }
        value: Audio.volume
        onMoved: Audio.setVolume(value)

        implicitWidth: OsdConfig.sizes.sliderWidth
        implicitHeight: OsdConfig.sizes.sliderHeight
    }

    VerticalSlider {
        icon: `brightness_${(Math.round(value * 6) + 1)}`
        value: root.monitor?.brightness ?? 0
        onMoved: root.monitor?.setBrightness(value)

        implicitWidth: OsdConfig.sizes.sliderWidth
        implicitHeight: OsdConfig.sizes.sliderHeight
    }
}
