#include "ActionHandler.hpp"

#include <QProcess>

ActionHandler::ActionHandler(QString action, QObject *parent) : QObject(parent), m_action(action)
{
    // Nothing needed here
}

bool ActionHandler::newWindow()
{
    return QProcess::startDetached(m_action);
}
