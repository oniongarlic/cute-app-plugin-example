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

    property list<PluginInterface> loadedPlugins: []
    property int loadedPluginCount: 0

    property list<PluginContent> pluginContents: []

    property var failedPlugins: []  
    property var internalPlugins: ['dummy', 'nonexistant']
    
    menuBar: MenuBar {
        id: mainMenu
        Menu {
            title: "File"            
            MenuItem {
                text: "Add..."
                onClicked: loadInteralPlugin("dummy")
            }
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
        SplitView {
            anchors.fill: parent
            RowLayout {
                id: crl
                SplitView.fillWidth: true
                SplitView.minimumWidth: 400
                spacing: 16
            }
            ColumnLayout {
                SplitView.fillWidth: true
                SplitView.minimumWidth: 300
                SplitView.maximumWidth: 500
                Label {
                    text: "Available plugins"
                }
                ListView {
                    id: pluginsList
                    model: internalPlugins
                    delegate: pluginDelegate
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                Label {
                    text: "Loaded plugins"
                }

                ListView {
                    id: loadedPluginsList
                    model: loadedPlugins
                    delegate: loadedPluginDelegate
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                Label {
                    text: "Content items: "+pluginContents.length
                }

                ListView {
                    id: contentItemsList
                    model: pluginContents
                    delegate: pluginContentDelegate
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                RowLayout {
                    Button {
                        text: "Unselect"
                        onClicked: cdSelectedGroup.checkState=Qt.Unchecked
                    }
                    CheckBox {
                        id: editContent
                        text: "Edit"
                    }
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

    ButtonGroup {
        id: cdSelectedGroup
    }

    Component {
        id: pluginContentDelegate
        ItemDelegate {
            id: _cd
            required property var modelData
            required property int index
            width: ListView.view.width            
            highlighted: ListView.isCurrentItem           
            height: r.height
            RowLayout {
                id: r
                width: parent.width
                ColumnLayout {
                    id: c
                    spacing: 4
                    Layout.fillWidth: true
                    Layout.minimumWidth: parent.width/4
                    Layout.maximumWidth:  parent.width/1.25
                    Text { text: modelData.objectName; }
                }
                Button {
                    text: "P"
                    onClicked: {
                        modelData.contextMenu.popup();
                    }
                }
                RadioButton {
                    text: "S"
                    Layout.fillWidth: false
                    ButtonGroup.group: cdSelectedGroup
                    enabled: editContent.checked
                    checked: modelData.isSelected && editContent.checked
                    onCheckedChanged: {
                        modelData.isSelected=checked
                    }
                }
                CheckBox {
                    text: "E"
                    Layout.fillWidth: false
                    checked: modelData.enabled
                    onCheckedChanged: {
                        modelData.enabled=checked
                    }
                }
                CheckBox {
                    text: "V"
                    Layout.fillWidth: false
                    checked: modelData.visible
                    onCheckedChanged: {
                        modelData.visible=checked
                    }
                }
            }

            onClicked: {
                console.debug(index)
                ListView.view.currentIndex=index;
            }

            onDoubleClicked: {
                ListView.view.currentIndex=index;

            }
        }
    }

    Component {
        id: pluginDelegate
        ItemDelegate {
            width: ListView.view.width
            text: modelData
            highlighted: ListView.isCurrentItem
            onClicked: {
                console.debug(index)
                ListView.view.currentIndex=index;
            }
        }
    }
    
    Component {
        id: loadedPluginDelegate
        ItemDelegate {
            required property var modelData
            required property int index
            text: modelData.pluginSerial +":"+ modelData.objectName+" : "+loadedPlugins[index].pluginFriendlyName
            width: ListView.view.width
            highlighted: ListView.isCurrentItem            
            onClicked: {
                console.debug(index)
                ListView.view.currentIndex=index;
            }
            onDoubleClicked: {
                console.debug(index)
                ListView.view.currentIndex=index;
                modelData.drawer.open();
                for (var i = 0; i < loadedPlugins.length; i++)
                    console.log("plugin", i, loadedPlugins[i].pluginFriendlyName)                
            }
            onPressAndHold: {
                modelData.menu.open();
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

        let c=null
        if (pi.hasContent) {
            c=pi.getContent(crl);
            c.visible=true
            pluginContents.push(c)
        }

        if (pi.hasMenu) {
            console.debug("Creating menu for plugin", name)
            mainMenu.addMenu(pi.getMenu(pi, c))
        } else {
            console.debug("Plugin has no menu");
        }
        
        if (pi.hasDrawer) {
            console.debug("Creating drawer for plugin", name)
            pi.getDrawer(root, c);
        } else {
            console.debug("Plugin has no drawer");
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
