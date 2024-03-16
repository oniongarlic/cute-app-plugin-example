import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtQml.XmlListModel
import QtQuick.Dialogs

import "plugins"

ApplicationWindow {
    id: root
    width: 1280
    height: 720
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
            MenuItem {
                text: "Add..."
                onClicked: loadPlugin("dummy")
            }
        }
    }
    
    footer: ToolBar {
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
    
    property list<PluginInterface> loadedPlugins: [];
    property int pluginCount: 1
    
    onLoadedPluginsChanged: console.debug(loadedPlugins)
    
    function loadPlugin(name) {
        console.debug("Loading plugin: "+name)
        let pdef="plugins/"+name+"/plugin.qml"
        let p=pluginLoaderComponent.createObject(root);
        p.setSource(pdef, { pluginSerial: pluginCount++ });
        if (p.status!=Loader.Ready) {
            console.debug("Failed to load plugin: "+name)
            return false
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
        loadPlugin("dummy")
    }
    
}
