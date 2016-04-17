package com.xl.wonhot {
	import com.xl.ui.wonhot.UICloseButton;
	import com.xl.wonhot.event.WonhotEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * 卡片播放器
	 * @author hmh
	 */
	public class CardPlayer extends Card {
		private var _width:int = 460;
		private var _height:int = 400;
		private var _client:Object;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _vo:Video;
		private var _closeBtn:UICloseButton;
		private var _link:String;
		
		public function CardPlayer() {
			
		}
		
		override protected function init():void {
			this.graphics.beginFill(0);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
			
			_nc = new NetConnection();
			_nc.connect(null);
			
			_vo = new Video(_width, _height);
			_vo.smoothing = true;
			this.addChild(_vo);
			
			_client = new Object();
			_client.onMetaData = onMetaDataHandler;
			
			_closeBtn = new UICloseButton();
			_closeBtn.x = _width - _closeBtn.width;
			this.addChild(_closeBtn);
			
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.buttonMode = true;
		}
		
		private function onClick(evt:MouseEvent):void {
			if (evt.target == _closeBtn) {
				this.dispatchEvent(new WonhotEvent(WonhotEvent.CLOSE));
			} else {
				this.dispatchEvent(new WonhotEvent(WonhotEvent.LINK));
			}
		}
		
		private function onMetaDataHandler(obj:Object):void {
		
		}
		
		private function statuEventHandler(evt:NetStatusEvent):void {
			Util.log("code :" + evt.info.code);
			switch (evt.info.code) {
				case 'NetConnection.Connect.Success': 
					break;
				case 'NetStream.Play.StreamNotFound': 
					/*_isError = true;
					 errHandler('load');*/
					break;
				case 'NetStream.Play.Start': 
					//dispatchEvent(new PauseEvent(PauseEvent.LOAD_COMPLETE));
					break;
				case 'NetStream.Buffer.Full': 
					//dispatchEvent(new PauseEvent(PauseEvent.LOAD_COMPLETE));
					break;
				case 'NetStream.Play.Stop': 
					break;
			}
		}
		
		private function asyerrorEventHandler(evt:AsyncErrorEvent):void {
			errHandler('load');
		}
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			//_isError = true;
			errHandler('load');
		}
		
		private function errHandler(type:String):void {
			//dispatchEvent(new PauseEvent(type == 'load' ? PauseEvent.LOAD_ERR : PauseEvent.PLAY_ERR));
		}
		
		private function addNetStreamEvent(ns:NetStream):void {
			ns.addEventListener(NetStatusEvent.NET_STATUS, statuEventHandler);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyerrorEventHandler);
			ns.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeNetStreamEvent(ns:NetStream):void {
			ns.removeEventListener(NetStatusEvent.NET_STATUS, statuEventHandler);
			ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyerrorEventHandler);
			ns.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		public function connectStream(url:String):void {
			clear();
			_ns = new NetStream(_nc);
			_ns.client = _client;
			_ns.soundTransform = new SoundTransform(0.5);
			addNetStreamEvent(_ns);
			_vo.attachNetStream(_ns);
			_ns.play(url);
		}
		
		public function clear():void {
			if (_ns) {
				_vo.attachNetStream(null);
				removeNetStreamEvent(_ns);
				_ns.close();
				_ns.client = {};
				_ns = null;
			}
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function get height():Number {
			return _height;
		}
		
		public function get link():String {
			return _link;
		}
		
		public function set link(value:String):void {
			_link = value;
		}
	}
}