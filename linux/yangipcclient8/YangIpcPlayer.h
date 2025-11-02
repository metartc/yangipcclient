//
// Copyright (c) 2019-2025 yanggaofeng
//

#ifndef INCLUDE_YANGIOS_YANGPLAYERIOSI_H_
#define INCLUDE_YANGIOS_YANGPLAYERIOSI_H_

#include "YangIpcPlayerDef.h"

class YangIpcPlayer {
public:
	YangIpcPlayer(){};
	virtual ~YangIpcPlayer(){};
	virtual void init()=0;

	virtual int32_t startPlay()=0;
	virtual int32_t stopPlay()=0;

	virtual bool mqttALive()=0;
	virtual int32_t startMqtt(char* serverTopic)=0;

	virtual void startAudio()=0;
	virtual void stopAudio()=0;

	virtual void initRender()=0;
	virtual YangRenderImage* getRenderImage()=0;

	virtual void setDecodeHw(bool isHw)=0;
	virtual void setLoglevel(int32_t logLevel)=0;
	virtual void setIceConfig(int32_t iceTransportPolicy,int32_t iceCandidateType)=0;
	virtual void setIceServer(char* ip,int32_t port,char* username,char* passwork)=0;
	virtual void setMqttServer(bool isTls,char* ip,int32_t port,char* username,char* passwork)=0;
};

extern "C"{
YANG_EXPORT_API YangIpcPlayer* yang_create_ipcPlayer8(YangPlayerMsgCallback* callback,bool isHd);
}

#endif /* SRC_YANGIOS_YANGPLAYERIOS_H_ */
