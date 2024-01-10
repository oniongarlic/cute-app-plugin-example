import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Plugin test application")
    
    menuBar: MenuBar {
        id: mainMenu
        Menu {
            title: "File"
            MenuItem {
                text: "Quit"
                onClicked: Qt.quit()
            }
        }
    }
    
    footer: ToolBar {
        id: toolbar
        RowLayout {
            
        }
    }
    
    StackView {
        id: stack
        anchors.fill: parent
    }
    
    function loadPlugin(name) {
        console.debug("Loading plugin: "+name)
        let pdef="plugins/"+name+"/plugin.qml"
        let p=pluginLoaderComponent.createObject(root, { });
        p.source=pdef;
        if (p.status!=Loader.Ready) {
            console.debug("Failed to load plugin: "+name)
            return false
        }
        
        let pi=p.item;
        
        let c=pi.createComponent(stack);
        
        c.visible=true

        if (pi.hasMenu) {
            console.debug("Creating plugin menu")
            mainMenu.addMenu(pi.getMenu(pi, c))
        }
        
        if (pi.hasDrawer) {
            console.debug("Creating plugin drawer")
            pi.getDrawer(root, c);
        }
        
        return true;
    }
    
    Component {
        id: pluginLoaderComponent
        Loader {
            id: pluginLoader
            onStatusChanged: if (pluginLoader.status == Loader.Ready) console.log('Loaded')
            onLoaded: {
                
            }
        }
    }
    
    Component.onCompleted: {
        loadPlugin("dummy")
    }
    
}
