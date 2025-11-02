//
// Copyright (c) 2019-2022 yanggaofeng
//
#include "yangrecordthread.h"
#include <QDebug>
#include <QMapIterator>

YangRecordThread::YangRecordThread()
{

    m_isLoop=0;
    m_video=nullptr;
    m_player=nullptr;


    m_sid=1;
    showType=1;

    m_isStart=0;
    m_isRender=false;
    m_playWidth=640;
    m_playHeight=480;
    m_playBuffer=new uint8_t[m_playWidth*m_playHeight*3/2];
    memset(m_playBuffer,0,m_playWidth*m_playHeight);
    memset(m_playBuffer+m_playWidth*m_playHeight,128,(m_playWidth*m_playHeight)>>1);
}

YangRecordThread::~YangRecordThread(){
    // m_ys=nullptr;
    // m_vb=NULL;
    m_video=nullptr;
    m_player=nullptr;
    //  m_vb=NULL;

    stopAll();
    yang_deleteA(m_playBuffer);
}
void YangRecordThread::stopAll(){
    if(m_isLoop){
        m_isLoop=0;
        while (m_isStart) {
            QThread::msleep(1);
        }
    }
    closeAll();
}
void YangRecordThread::initPara(){

}
void YangRecordThread::closeAll(){
    //clearRender();
}


void YangRecordThread::setBlackBk(){

}
void YangRecordThread::render(){
    YangRenderImage* img=NULL;
    if(m_isRender&&m_player){
        img=m_player->getRenderImage();


        if(img&&m_video){
            m_video->playVideo(img->payload,img->width,img->height);
        }

        img=NULL;
    }else{
        if(m_video) m_video->playVideo(m_playBuffer,m_playWidth,m_playHeight);
    }
}

void YangRecordThread::run(){
    // init();

    m_isLoop=1;
    m_isStart=1;


    while(m_isLoop){

        QThread::msleep(10);
        render();
    }
    m_isStart=0;
    // closeAll();
}
