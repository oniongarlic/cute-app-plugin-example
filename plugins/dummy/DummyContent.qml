import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ".."

PluginContent {
    visible: false
    objectName: "DummyTextFields"

    property alias primaryText: t1.text
    property alias secondaryText: t2.text
    property alias extraText: t3.text
    
    property var date: new Date;
    
    property bool timeVisible: true
    
    Layout.fillWidth: true
    Layout.fillHeight: true

    property bool boldTime: false

    onBoldTimeChanged: console.debug(boldTime)

    Menu {
        id: cMenu
        MenuItem {
            id: boldTimeMenu
            text: "Bold"
            checkable: true
            checked: boldTime
            onCheckedChanged: boldTime=checked
        }
    }

    Component.onCompleted: {
        contextMenu=cMenu
    }
    
    Timer {
        id: tc
        interval: 1000
        running: parent.visible && parent.enabled
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            date = new Date;
        }
    }
    
    ColumnLayout {
        id: c
        Text {
            id: t1
            font.pixelSize: 32
            text: "t1 mm.dd.yyyy"
        }
        Text {
            id: t2
            font.pixelSize: 32
            text: "t2 mm.dd.yyyy"
        }
        Label {
            id: t3
            visible: timeVisible
            font.pixelSize: 32
            font.bold: boldTime
            text: Qt.formatTime(date, "hh:mm:ss");
        }
    }
}
