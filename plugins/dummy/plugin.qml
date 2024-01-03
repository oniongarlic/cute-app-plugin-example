import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ".."

PluginInterface {
    id: plugin
    
    objectName: "dummyPlugin"
    
    hasMenu: true
    hasDrawer: true
    
    Component {
        id: pluginMenu
        Menu {
            title: "Dummy"
            property DummyContent content;
            MenuItem {
                text: "Manage dummy"
                onClicked: drawer.open()
            }
            MenuItem {
                text: "Test 2"
                onClicked: console.debug("Dummy test 2")
            }
        }
    }
    
    Component {
        id: pluginContainer
        DummyContent {
            
        }
    }
    
    Component {
        id: pluginDrawer
        
        Drawer {
            id: clapperDrawer
            dragMargin: 0
            width: parent.width/1.25
            height: parent.height
            
            property DummyContent content;
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8
                
                Switch {
                    id: telepromptMsgSwitch
                    Layout.alignment: Qt.AlignLeft
                    text: "Display"
                    checked: content.visible
                    onCheckedChanged: {
                        content.visible=checked
                    }
                }
                
                TextField {
                    id: textl3Primary
                    Layout.fillWidth: true
                    placeholderText: "Primary (name, etc)"
                    selectByMouse: true
                    text: content.primaryText
                    onAccepted: {
                        content.primaryText=text;
                    }
                }
                TextField {
                    id: textl3Secondary
                    Layout.fillWidth: true
                    placeholderText: "Secondary (title, e-mail, etc)"
                    selectByMouse: true
                    text: content.secondaryText
                    onAccepted: {
                        content.secondaryText=text;
                    }
                }
                TextField {
                    id: textl3Topic
                    Layout.fillWidth: true
                    placeholderText: "Topic/Keyword"
                    selectByMouse: true
                }
            }
        }
    }
}
