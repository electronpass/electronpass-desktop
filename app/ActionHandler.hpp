#ifndef ACTION_HANDLER_HPP
#define ACTION_HANDLER_HPP

#include <QObject>

class ActionHandler : public QObject
{
Q_OBJECT
public:
    explicit ActionHandler(QString action, QObject *parent = 0);

public slots:
    bool newWindow();

private:
    QString m_action;
};

#endif // ACTION_HANDLER_HPP
