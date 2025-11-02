//
// Copyright (c) 2019-2025 yanggaofeng
//
#ifndef MAINWINDOW_H
#define MAINWINDOW_H
#include <QVBoxLayout>
#include <QMainWindow>
#include <string>

#include "video/yangrecordthread.h"
#include <yangclient8.h>

#include "yangplayer/YangPlayWidget.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    YangRecordThread *m_videoThread;
    YangIpcClient8 *m_player;

    YangPlayWidget *m_videoWin;

    YangPlayerMsgCallback m_callback;
    bool m_isStartplay;
    bool m_inited;
    void initVideoThread(YangRecordThread *prt);

    void success();
    void failure(int32_t errcode);

    signals:
       void RtcConnectFailure(int errcode);
protected:


private slots:
    void connectFailure(int errcode);

void on_m_b_play_clicked();

void on_m_c_mqttIsTls_clicked();

private:
    bool m_isTls;
    char m_mqttIP[64];
    int32_t m_mqttPort;
    Ui::MainWindow *ui;

    //std::string serverIp,app,stream;
   // std::string localServer;
    //int localPort;
    QWidget *m_centerWdiget;
    QVBoxLayout *m_vb;
    QHBoxLayout *m_hb1;
    QHBoxLayout *m_hb2;
private:


    void yangstyle();

};
#endif // MAINWINDOW_H
