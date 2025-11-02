/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 6.9.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QPushButton *m_b_play;
    QLabel *label;
    QLineEdit *m_e_mqttIp;
    QLineEdit *m_e_mqttPort;
    QLabel *label_2;
    QCheckBox *m_c_mqttIsTls;
    QMenuBar *menubar;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName("MainWindow");
        MainWindow->resize(1101, 689);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName("centralwidget");
        m_b_play = new QPushButton(centralwidget);
        m_b_play->setObjectName("m_b_play");
        m_b_play->setGeometry(QRect(680, 10, 151, 41));
        label = new QLabel(centralwidget);
        label->setObjectName("label");
        label->setGeometry(QRect(400, 20, 71, 34));
        m_e_mqttIp = new QLineEdit(centralwidget);
        m_e_mqttIp->setObjectName("m_e_mqttIp");
        m_e_mqttIp->setGeometry(QRect(110, 10, 251, 42));
        m_e_mqttPort = new QLineEdit(centralwidget);
        m_e_mqttPort->setObjectName("m_e_mqttPort");
        m_e_mqttPort->setGeometry(QRect(470, 10, 113, 42));
        label_2 = new QLabel(centralwidget);
        label_2->setObjectName("label_2");
        label_2->setGeometry(QRect(40, 10, 41, 34));
        m_c_mqttIsTls = new QCheckBox(centralwidget);
        m_c_mqttIsTls->setObjectName("m_c_mqttIsTls");
        m_c_mqttIsTls->setGeometry(QRect(900, 10, 91, 41));
        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName("menubar");
        menubar->setGeometry(QRect(0, 0, 1101, 48));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName("statusbar");
        MainWindow->setStatusBar(statusbar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "webrtc\346\213\211\346\265\201\346\222\255\346\224\276demo", nullptr));
        m_b_play->setText(QCoreApplication::translate("MainWindow", "Play", nullptr));
        label->setText(QCoreApplication::translate("MainWindow", "Port:", nullptr));
        label_2->setText(QCoreApplication::translate("MainWindow", "IP:", nullptr));
        m_c_mqttIsTls->setText(QCoreApplication::translate("MainWindow", "SSL", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
