//
// Copyright (c) 2019-2022 yanggaofeng
//
#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    YangIpcPlayer* player=yang_create_ipcPlayer8(&w.m_callback,true);
   // YangIpcPlayer* player=YangIpcPlayer::createIpcPlayer(&w.m_callback,false);
    //player->init();
    w.m_player=player;

    YangRecordThread videoThread;
    videoThread.m_player=player;
    w.m_videoThread=&videoThread;
    w.initVideoThread(&videoThread);
    w.show();
    videoThread.start();
   // player->start();
    return a.exec();
}
