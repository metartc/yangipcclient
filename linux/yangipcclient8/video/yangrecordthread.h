//
// Copyright (c) 2019-2022 yanggaofeng
//
#ifndef YANGTHREAD1_H
#define YANGTHREAD1_H
#include <QThread>
#include <QVector>

#include "YangIpcPlayer.h"
#include <yangplayer/YangPlayWidget.h>

class YangRecordThread : public QThread
{
public:
    YangRecordThread();
    virtual ~YangRecordThread();

    int m_isLoop;
    void initPara();

    YangPlayWidget *m_video;


    YangIpcPlayer* m_player;
    bool m_isRender;

    int m_sid;
    void stopAll();
    int showType;

    void setBlackBk();

private:
    void render();
    void closeAll();


    int m_isStart;
    int m_playWidth;
    int m_playHeight;
    uint8_t* m_playBuffer;

private:
    virtual void run();
};

#endif // YANGTHREAD_H
