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

    property var loadedPlugins: []

    property var internalPlugins: ['dummy', 'nonexistant']
    
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

    function loadExternalPlugin(dir) {
        return loadFromDirectoryPlugin("file:/"+dir)
    }

    function loadInteralPlugin(name) {
        console.debug("Loading internal plugin: "+name)
        return loadFromDirectoryPlugin("plugins/"+name)
    }
    
    function loadFromDirectoryPlugin(name) {
        console.debug("Loading plugin from: "+name)

        let p=pluginLoaderComponent.createObject(root, { });

        p.source=name+"/plugin.qml";
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

        loadedPlugins.push(p)
        
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

    function loadAllPlugins() {
        console.debug("Loading internal plugins")
        internalPlugins.forEach(pn=>loadInteralPlugin(pn))

        console.debug("Loading external plugins")
        console.debug(plugins)
        plugins.forEach(pn=>loadExternalPlugin(pn))
    }
    
    Component.onCompleted: {
        loadAllPlugins();
    }
    
}
