import QtQuick 
import QtQuick.Layouts

import ".."

PluginContent {
    visible: false
    objectName: "DummyTextFields"
    anchors.centerIn: parent
    
    property alias primaryText: t1.text
    property alias secondaryText: t2.text
    property alias extraText: t3.text
    
    ColumnLayout {
        anchors.fill: parent
        Text {
            id: t1
            text: "t1 mm.dd.yyyy"
        }
        Text {
            id: t2
            text: "t2 mm.dd.yyyy"
        }
        Text {
            id: t3
            text: "t3 mm.dd.yyyy"
        }
    }
    
}
