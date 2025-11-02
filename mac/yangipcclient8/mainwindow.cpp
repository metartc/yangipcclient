//
// Copyright (c) 2019-2022 yanggaofeng
//
#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QSettings>
#include <string.h>


static void yang_success(void* session){
    MainWindow* client=(MainWindow*)session;
    if(client==NULL)
        return;
    client->success();
}

static void yang_failure(void* session,int32_t  errcode){
    MainWindow* client=(MainWindow*)session;
    if(client==NULL)
        return;
    client->failure(errcode);
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    yangstyle();
    m_centerWdiget=new QWidget(this);
    m_vb=new QVBoxLayout();

    setCentralWidget(m_centerWdiget);
    m_centerWdiget->setLayout(m_vb);
    //m_vb->setMargin(0);
    m_vb->setSpacing(0);

    m_videoWin=new YangPlayWidget(this);


    m_hb1=new QHBoxLayout();
    m_hb2=new QHBoxLayout();
    m_hb1->addWidget(ui->label_2);
    m_hb1->addWidget(ui->m_e_mqttIp);
    m_hb1->addWidget(ui->label);
    m_hb1->addWidget(ui->m_e_mqttPort);


    m_hb1->addWidget(ui->m_b_play);
    m_hb1->addWidget(ui->m_c_mqttIsTls);

    m_hb2->addWidget(m_videoWin);
    m_vb->addLayout(m_hb1);
    m_vb->addLayout(m_hb2);
    m_vb->setStretchFactor(m_hb1,1);
    m_vb->setStretchFactor(m_hb2,10);

    memset(m_mqttIP,0,sizeof(m_mqttIP));
    m_mqttPort=1883;
    m_isStartplay=false;
    m_inited=false;
    m_isTls=false;

    connect(this,SIGNAL(RtcConnectFailure(int)),SLOT(connectFailure(int)));


    m_callback.session=this;
    m_callback.success=yang_success;
    m_callback.failure=yang_failure;


    ui->m_e_mqttIp->setText(QString("192.168.0.104"));
    ui->m_e_mqttPort->setText("1883");


}

MainWindow::~MainWindow()
{
    delete ui;
    m_videoThread->m_player=NULL;

    if(  m_isStartplay&&m_player) {
        m_isStartplay=!m_isStartplay;
       // m_player->close();
        m_player->stopPlay(m_player->session);
         QThread::msleep(2000);
    }

    yang_delete(m_videoWin);
    yang_destroy_ipcClient8(m_player);
    if(m_player){
         free(m_player);
         m_player=NULL;
    }
   // yang_closeLogFile();
   // yang_delete(m_context);


}

void MainWindow::yangstyle(){
    setStyleSheet(R"(
                  QPushButton {
                  background-color: #ffffff;
                  border: 1px solid #dcdfe6;
                  padding: 10px;
                  border-radius: 5px;
                  }

                  QPushButton:hover {
                  background-color: #ecf5ff;
                  color: #409eff;
                  }

                  QPushButton:pressed, QPushButton:checked {
                  border: 1px solid #3a8ee6;
                  color: #409eff;
                  }

                  #button3 {
                  border-radius: 20px;
                  }
                  )");

}


void MainWindow::success(){
    if(m_isStartplay) return;
    ui->m_b_play->setText("stop");

    m_isStartplay=!m_isStartplay;

    m_videoThread->m_player= m_player;
    m_videoThread->m_isRender=true;


}
void MainWindow::failure(int32_t errcode){
    if(errcode==3){
        if(m_isStartplay){
            on_m_b_play_clicked();
        }
        return;
    }

  //  emit RtcConnectFailure(errcode);


}


void MainWindow::connectFailure(int errcode){
    QMessageBox::about(NULL, "Error", "play error("+QString::number(errcode)+")!");
    on_m_b_play_clicked();
}

void MainWindow::initVideoThread(YangRecordThread *prt){
    m_videoThread=prt;
    m_videoThread->m_video=m_videoWin;
    m_videoThread->initPara();
    // m_videoThread->m_syn= m_context->streams.m_playBuffer;

}

void MainWindow::on_m_b_play_clicked()
{

    if(!m_isStartplay){


        if(m_player){
            if(!m_inited){
                memset(m_mqttIP,0,sizeof(m_mqttIP));
                strcpy(m_mqttIP,ui->m_e_mqttIp->text().toStdString().c_str());
                m_mqttPort=atoi(ui->m_e_mqttPort->text().toStdString().c_str());
                m_isTls=(ui->m_c_mqttIsTls->checkState()==Qt::CheckState::Checked)?yangtrue:yangfalse;

                m_player->setLoglevel(m_player->session,5);
                m_player->setDecodeHw(m_player->session,yangfalse);
                m_player->setMqttServer(m_player->session,m_isTls,m_mqttIP,m_mqttPort,NULL,NULL);
                m_player->setIceConfig(m_player->session,0,2);
                m_player->setIceServer(m_player->session,(char*)"192.168.0.104",3478,(char*)"metartc",(char*)"metartc");

                m_inited=true;
            }

            if(m_player->startMqtt(m_player->session,(char*)"test1001")!=Yang_Ok)
                return;

            QThread::msleep(300);

            //  memset(m_conf.sfuUrl,0,sizeof(m_conf.sfuUrl));
            //strcpy(m_conf.sfuUrl,(char*)ui->m_url->text().toStdString().c_str());
            m_player->startPlay(m_player->session);
        }
    }else{
        // if(m_context->avinfo.sys.ipcServerType==YangIPCServerHttp){
        m_videoThread->m_isRender=false;
        ui->m_b_play->setText("play");

        QThread::msleep(100);

        m_isStartplay=!m_isStartplay;
        m_videoThread->m_player= NULL;
        if(m_player)
            m_player->stopPlay(m_player->session);
        return;
        // }


    }
}





void MainWindow::on_m_c_mqttIsTls_clicked()
{
    if(ui->m_c_mqttIsTls->checkState()==Qt::CheckState::Checked){

        //m_context->avinfo.sys.enableHttps=yangtrue;
    }else{

        //m_context->avinfo.sys.enableHttps=yangfalse;
    }
}
