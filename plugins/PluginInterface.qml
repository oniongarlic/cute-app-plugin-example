import QtQuick 
import QtQuick.Controls

QtObject {
    id: plugin

    // Does the plugin have visual content
    property bool hasContent: false;
    property bool singleInstantContent: true;

    property bool hasMenu: false;
    property bool hasDrawer: false;
    
    property int pluginSerial: 2138213123;
    property string pluginFriendlyName: "Not set"
    
    onPluginSerialChanged: console.debug(pluginSerial)
    
    // Common plugin components
    property Menu menu;    
    property Drawer drawer;
    
    property list<PluginContent> contents;
    
    default property list<QtObject> children;

    Component.onCompleted: {
        console.debug("Completed: "+objectName)
    }

    Component.onDestruction: {
        console.debug("Destryoing: "+objectName)
    }
    
    function getMenu(mparent, c) {
        menu=pluginMenu.createObject(mparent, { content: c });
        return menu
    }
    
    function getDrawer(dparent, c) {
        drawer=pluginDrawer.createObject(dparent, { content: c });
        return drawer
    }
    
    function getContent(vparent, i) {
        let c=pluginContainer.createObject(vparent)
        contents.push(c)
        return c;
    }   
}
