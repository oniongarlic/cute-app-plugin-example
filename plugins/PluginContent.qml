import QtQuick 
import QtQuick.Controls

Item {
    objectName: "Not set"

    property bool isSelected: false
    property Menu contextMenu;

    onIsSelectedChanged: console.debug(isSelected)

    function show() {
        
    }
    function hide() {
        
    }
    function start() {
        
    }
    function stop() {
        
    }

    Rectangle {
        visible: isSelected
        z: 100
        color: "transparent"
        width: parent.width
        height: parent.height
        border.width: 2
        border.color: "red"
    }
}
