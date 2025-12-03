<template>
  <view class="page-wrapper">
	   <view id="native-view-container" class="native-container"></view>
	   <view class="button-row">
		  <button class="btn" @click="startStream" :disabled="isPlaying">开始播放</button>   
		  <button class="btn" @click="stopStream" :disabled="!isPlaying">停止播放</button>
		</view>
</view>
</template>
<style>
	.page-wrapper {
	  box-sizing: border-box;
	}
	.button-row {
	  display: flex;
	  justify-content: space-between; /* 两端对齐 */
	  padding: 0 20rpx; /* 左右留点边距 */
	  margin-top: 20rpx;
	}
	
	.btn {
	  flex: 1; 
	  margin: 0 10rpx; 
	}

	.native-container {
	  width: 100%;
	  height: calc(100vh - 80px);
	  background-color: #f0f0f0;
	}

	.title {
		font-size: 18px;
		color: #8f8f94;
		text-align: center;
	}	
</style>

<script>
import YangConfig from '@/utils/YangConfig.js';
export default {
 data() {
    return {
      isPlaying: false,
	  glPlugin:null
    };
  },

  onReady() {
	  this.glPlugin = uni.requireNativePlugin('yang-opengl-view');
	  
      this.$nextTick(() => {
        setTimeout(() => {
          this.initNativeView();
        }, 500); 
      });
    },
   onUnload() {
      if (this.isPlaying ) {
        //this.glPlugin.stopPlay();
        this.isPlaying = false; 
      }
    },
  methods: {
	  async requestMicrophonePermission() {
	    const permission = 'android.permission.RECORD_AUDIO';
	    const result = await new Promise((resolve) => {
	      plus.android.requestPermissions( 
	        [permission],
	        (success) => resolve(true),
	        (error) => resolve(false) 
	      );
	    });
	    return result;
	  },
	initNativeView() {
	  const query = uni.createSelectorQuery().in(this);
	  query.select('#native-view-container')
			  .boundingClientRect()
			  .exec(res => {
				if (!res || !res[0]) {
				  uni.showToast({ title: '获取容器信息失败', icon: 'none' });
				  return;
				}
				const sys = uni.getSystemInfoSync();
				const pixelRatio = sys.pixelRatio
				const containerInfo = res[0];
				var yang_x=containerInfo.left;
				var yang_y=70;//containerInfo.top;//containerInfo.top;//this.safeAreaTop;//
				var yang_width=containerInfo.width;
				var yang_height=containerInfo.height;
				if (uni.getSystemInfoSync().platform === 'android'){
					yang_x=Math.round(containerInfo.left*pixelRatio);
					yang_y=Math.round(76*pixelRatio);//containerInfo.top;//this.safeAreaTop;//		
					yang_width=Math.round(containerInfo.width*pixelRatio);
					yang_height=Math.round(containerInfo.height*pixelRatio)
				}
				console.log("containerInfo="+JSON.stringify(containerInfo));
				console.log("yang_x="+yang_x+",yang_y="+yang_y+",width="+yang_width+",height="+yang_height);
				this.glPlugin.createOpenGLView(yang_x,yang_y,yang_width,yang_height, (result) => {
		
				  if (result.code === 0) {
					uni.showToast({ title: 'Yang View 创建成功', icon: 'success' });
				  } else {
					uni.showToast({ title: '创建失败: ' + result.message, icon: 'none' });
				  }
				});
			  });
	},
	async startStream(){
		if (uni.getSystemInfoSync().platform === 'android') {
		    const granted = await this.requestMicrophonePermission();
		    if (!granted) {
		      uni.showToast({ title: '需要麦克风权限', icon: 'none' });
		      return;	
		    }
		}
		
		if(this.glPlugin==null){
			uni.showToast({
			  title: '未找到原生插件',
			  icon: 'none'
			});
			return;
		} 
		
	   if(!YangConfig.isInited){
		  this.glPlugin.setLoglevel(YangConfig.logLevel);
		  this.glPlugin.setDecodeHw(YangConfig.decoderSoft);
		  this.glPlugin.setIceConfig(0,2);
		  this.glPlugin.setMqttServer(YangConfig.mqttServerIp,YangConfig.mqttPort,YangConfig.mqttUsername,YangConfig.mqttPassword);
		  this.glPlugin.setIceServer(YangConfig.iceServerIp,YangConfig.icePort,YangConfig.iceUsername,YangConfig.icePassword);
		  YangConfig.isInited=true;
		} 
	   this.glPlugin.play("test1001", (result) => {

		   if (result.code === 0) {
		         this.isPlaying=true;
		     } else {
		         console.error("Fail:", result.message);
		     }
		  }
	   );  
	},
	stopStream(){
		if(this.glPlugin==null){
			uni.showToast({
			  title: '未找到原生插件',
			  icon: 'none'
			});
			return;
		} 
		this.glPlugin.unplay();
		this.isPlaying=false;
	}
  }
}
</script>
