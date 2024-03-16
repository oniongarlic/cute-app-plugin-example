import QtQuick 
import QtQuick.Controls

QtObject {
    id: plugin
    
    property bool hasMenu: false
    property bool hasDrawer: false;
    
    property int pluginSerial: 2138213123;
    property string pluginFriendlyName: "Not set"
    
    onPluginSerialChanged: console.debug(pluginSerial)
    
    // Common plugin components
    property Menu menu;    
    property Drawer drawer;
    
    property list<PluginContent> components;
    
    default property list<QtObject> children;
    
    function getMenu(mparent, c) {
        menu=pluginMenu.createObject(mparent, { content: c });
        return menu
    }
    
    function getDrawer(dparent, c) {
        drawer=pluginDrawer.createObject(dparent, { content: c });
        return drawer
    }
    
    Component.onCompleted: {
        console.debug("Completed: "+objectName)
    }
    
    Component.onDestruction: {
        console.debug("Destryoing: "+objectName)
    }
    
    function createComponent(vparent, i) {
        let c=pluginContainer.createObject(vparent)
        components.push(c)
        return c;
    }
    
}
