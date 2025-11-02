//
// Copyright (c) 2019-2022 yanggaofeng
//
#include "mainwindow.h"

#include <QApplication>
#if defined (__APPLE__)
#include <video/yangrequest.h>
#endif
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    YangIpcClient8* player=(YangIpcClient8*)calloc(sizeof(YangIpcClient8),1);
    yang_create_ipcClient8(player,&w.m_callback,yangtrue);
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
#if defined (__APPLE__)
    yang_requestMicrophone();
#endif
    return a.exec();
}
