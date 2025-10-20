pragma ComponentBehavior: Bound
import qs.config
import Quickshell
import QtQuick
import QtQuick.Layouts
ColumnLayout {
  required property ShellScreen screen
  spacing: Appearance.spacing.normal
  Repeater {
      id: repeater

      model: Config.bar.entries
      DelegateChooser {
          role: "id"

          DelegateChoice {
              roleValue: "spacer"
              delegate: WrappedLoader {
                  Layout.fillHeight: enabled
              }
          }
          DelegateChoice {
              roleValue: "logo"
              delegate: WrappedLoader {
                  sourceComponent: OsIcon {}
              }
          }
        }
    }
    component WrappedLoader: Loader {
        required property bool enabled
        required property string id
        required property int index

        function findFirstEnabled(): Item {
            const count = repeater.count;
            for (let i = 0; i < count; i++) {
                const item = repeater.itemAt(i);
                if (item?.enabled)
                    return item;
            }
            return null;
        }

        function findLastEnabled(): Item {
            for (let i = repeater.count - 1; i >= 0; i--) {
                const item = repeater.itemAt(i);
                if (item?.enabled)
                    return item;
            }
            return null;
        }

        Layout.alignment: Qt.AlignHCenter
        Layout.leftMargin: root.padding
        Layout.rightMargin: root.padding

        // Cursed ahh thing to add padding to first and last enabled components
        Layout.topMargin: findFirstEnabled() === this ? root.vPadding : 0
        Layout.bottomMargin: findLastEnabled() === this ? root.vPadding : 0

        visible: enabled
        active: enabled
    }
}
