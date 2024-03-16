import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import "plugins"

ApplicationWindow {
    id: root
    width: 1280
    height: 720
    visible: true
    title: qsTr("Plugin test application")

    property var loadedPlugins: []
    property var failedPlugins: []

    property int loadedPluginCount: 0
    
    property var internalPlugins: ['dummy', 'nonexistant']
    
    menuBar: MenuBar {
        id: mainMenu
        Menu {
            title: "File"
            MenuItem {
                text: "Quit"
                onClicked: Qt.quit()
            }
            MenuItem {
                text: "Add..."
                onClicked: loadInteralPlugin("dummy")
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
        SplitView {
            anchors.fill: parent
            RowLayout {
                id: crl
                SplitView.fillWidth: true
                spacing: 16
            }
            ColumnLayout {
                SplitView.fillWidth: true
                SplitView.minimumWidth: 200
                Label {
                    text: "Loaded plugins"
                }

                ListView {
                    id: pluginsList
                    model: loadedPlugins
                    delegate: pluginDelegate
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }

    function loadExternalPlugin(dir) {
        console.debug("Loading external plugin from: "+dir)
        return loadFromDirectoryPlugin("file:/"+dir)
    }

    function loadInteralPlugin(name) {
        console.debug("Loading internal plugin: "+name)
        return loadFromDirectoryPlugin("plugins/"+name)
    }
    
    Component {
        id: pluginDelegate
        ItemDelegate {
            required property var modelData
            required property int index
            text: modelData.objectName+" : "+loadedPlugins[index].pluginFriendlyName
            width: ListView.view.width
            highlighted: ListView.isCurrentItem
            onClicked: {
                ListView.currentIndex=index;
            }
            onDoubleClicked: {
                ListView.currentIndex=index;
                for (var i = 0; i < loadedPlugins.length; i++)
                    console.log("plugin", i, loadedPlugins[i].pluginFriendlyName)
            }
        }
    }
    
    function loadFromDirectoryPlugin(name) {
        console.debug("Loading plugin from: "+name)
        let p=pluginLoaderComponent.createObject(root);
        p.setSource(name+"/plugin.qml", { pluginSerial: loadedPluginCount++ });

        if (p.status!=Loader.Ready) {
            console.debug("Failed to load plugin: "+name)
            failedPlugins.push(name)
            return true
        }
        
        let pi=p.item;

        let c=pi.createComponent(crl);
        c.visible=true
        
        loadedPlugins.push(c)

        if (pi.hasMenu) {
            console.debug("Creating plugin menu")
            mainMenu.addMenu(pi.getMenu(pi, c))
        }
        
        if (pi.hasDrawer) {
            console.debug("Creating plugin drawer")
            pi.getDrawer(root, c);
        }

        loadedPlugins.push(pi)
        
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

        console.debug(loadedPlugins)
        console.debug(failedPlugins)
    }
    
}
