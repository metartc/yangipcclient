
//
// Copyright (c) 2019-2023 yanggaofeng
//

'use strict';


var datachannel=null;
var yang_hasDatachannel=false;

function yang_trace(msg){
		console.log("trace:"+msg);
}
function handleAnswer(msg){

		
}

// Depends on adapter-7.4.0.min.js from https://github.com/webrtc/adapter
// Async-await-promise based SRS RTC Player.
function YangRtcPlayerAsync() {	
    var self = {};
    if(yang_mediaServerType==Yang_ConnectType_P2p){
		//self.pc = new RTCPeerConnection({iceServers: yang_iceServer,iceTransportPolicy: 'relay'});
		self.pc = new RTCPeerConnection({iceServers: yang_iceServer});
	}else{
		self.pc = new RTCPeerConnection(null);
	}
		
		
	self.pc.onconnectionstatechange=function(event){
		console.log("connection state change: ", self.pc.connectionState);
	
	}
	
	
	self.pc.onicecandidate = async (ev) => {
		//console.log("pc.localDescription====\n"+self.pc.localDescription.sdp);
       // console.log('=======>' + JSON.stringify(ev.candidate));
        if(ev.candidate==null) return;   
		if(yang_mediaServerType==Yang_ConnectType_P2p){
			var candidateStr=JSON.stringify(ev.candidate);
			if(candidateStr.indexOf(".local")!=-1){
				console.log("=======>mdns ip,please config ice server ");
				return;
			}else{
				 console.log("=======>"+JSON.stringify(ev.candidate));
				sendCandidate(candidateStr);
			}
		}
    };
	
	if(yang_hasDatachannel){
	
			datachannel=self.pc.createDataChannel('chat');
			datachannel.onopen = function(event) {
			console.log("datachannel onopen");
			}
			datachannel.onmessage = function(event) {
			  console.log("receive message: ", event.data);
			  $('#datachannel_recv').val(event.data);
			}
			datachannel.onerror=function(event) {
			  console.log("datachannel error: ", event.data);
			}
			datachannel.onclose=function(event) {
			  console.log("datachannel close: ");
			}
			
	}

	

	self.answerPlay = async function(remoteSdp) {
        //self.pc.addTransceiver("audio", {direction: "sendrecv"});
        //self.pc.addTransceiver("audio", {direction: "recvonly"});
        self.pc.addTransceiver("video", {direction: "recvonly"});	
        var stream = await navigator.mediaDevices.getUserMedia({ video: false, audio: true});
		stream.getTracks().forEach(function (track) {
            self.pc.addTrack(track,stream);
        });
        console.log("remote sdp:\n"+remoteSdp);
		await self.pc.setRemoteDescription(new RTCSessionDescription({type: 'offer', sdp: remoteSdp}));
  
		const answer = await self.pc.createAnswer();
		     
		await self.pc.setLocalDescription(answer);
		
		 var session = await new Promise(function(resolve, reject) {    	 
			console.log("answer sdp:\n"+answer.sdp);
           sendMqttMsg(Yang_Request_Answer,null,answer.sdp+"");
        });
        
        session.simulator = conf.schema + '//' + conf.urlObject.server + ':' + conf.port + '/rtc/v1/nack/';

        return session;
    };


	self.playP2p = async function() {   
        self.pc.addTransceiver("audio", {direction: "sendrecv"});
        self.pc.addTransceiver("video", {direction: "recvonly"});
		
		//var stream = await navigator.mediaDevices.getUserMedia({ video: false, audio: {
		//	sampleRate: 8000,
		//	echoCancellation: true, noiseSuppression: true, 
		//	autoGainControl: true,channelCount: 1
		//	}
		//});
		var stream = await navigator.mediaDevices.getUserMedia({ video: false, audio: true});
		stream.getTracks().forEach(function (track) {
            self.pc.addTrack(track,stream);
        });
		
        var offer = await self.pc.createOffer();
        await self.pc.setLocalDescription(offer);
        var session = await new Promise(function(resolve, reject) {    	 
			console.log("sdp"+offer.sdp);
           sendMqttMsg(Yang_Request_ConnectSdp,null,offer.sdp);	
        });
        
        session.simulator = conf.schema + '//' + conf.urlObject.server + ':' + conf.port + '/rtc/v1/nack/';

        return session;
    };
    

    // Close the player.
    self.close = function() {
		if(datachannel) {
			datachannel.close();
			datachannel=null;
		}
        self.pc && self.pc.close();
        self.pc = null;
        
    };

    // The callback when got remote track.
    // Note that the onaddstream is deprecated, @see https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/onaddstream
    self.ontrack = function (event) {
        // https://webrtc.org/getting-started/remote-streams
        self.stream.addTrack(event.track);
    };

    // Internal APIs.
    self.__internal = {
        defaultPath: '/rtc/v1/play/',
        prepareUrl: function (webrtcUrl) {
            var urlObject = yang_url_parse(webrtcUrl);
			var schema=chk_https.checked?"https:":"http:";
            var port = urlObject.port || 1985;
            if (schema === 'https:') {
                port = urlObject.port || 443;
            }

            // @see https://github.com/rtcdn/rtcdn-draft
            var api = urlObject.user_query.play || self.__internal.defaultPath;
            if (api.lastIndexOf('/') !== api.length - 1) {
                api += '/';
            }

            apiUrl = schema + '//' + urlObject.server + ':' + port + api;
            for (var key in urlObject.user_query) {
                if (key !== 'api' && key !== 'play') {
                    apiUrl += '&' + key + '=' + urlObject.user_query[key];
                }
            }
            // Replace /rtc/v1/play/&k=v to /rtc/v1/play/?k=v
            var apiUrl = apiUrl.replace(api + '&', api + '?');

            var streamUrl = urlObject.url;

            return {
                apiUrl: apiUrl, streamUrl: streamUrl, schema: schema, urlObject: urlObject, port: port,
                tid: Number(parseInt(new Date().getTime()*Math.random()*100)).toString(16).substr(0, 7)
            };
        }        
    };



    // Create a stream to add track to the stream, @see https://webrtc.org/getting-started/remote-streams
    self.stream = new MediaStream();

    // https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/ontrack
    self.pc.ontrack = function(event) {
        if (self.ontrack) {
            self.ontrack(event);
        }
    };

    return self;
}
