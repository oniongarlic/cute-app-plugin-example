#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QDirIterator>

QStringList plugins;

void scanPluginDirectory(const QString &path)
{
    //QDir dir(path);
    //plugins << dir.entryList(QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot);
    //return;

    QDirIterator it(path, QDir::AllDirs | QDir::Files | QDir::NoDotAndDotDot, QDirIterator::NoIteratorFlags);
    while (it.hasNext()) {
        QString p=it.next();
        plugins << it.filePath();
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    scanPluginDirectory("/opt/plugintest/plugins");

    // scanPluginDirectory("/opt/plugintest/plugins");

    qDebug() << "Plugin directories found: " << plugins;

    QQmlContext* rootContext = engine.rootContext();
    rootContext->setContextProperty("plugins", plugins);

    engine.loadFromModule("plugintest", "Main");
    
    return app.exec();
}
