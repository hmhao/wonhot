package com.xl.wonhot {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	/**
	 * 卡片管理类
	 * @author hmh
	 */
	public class CardManager extends EventDispatcher {
		private var _cards:Array;
		private var _player:CardPlayer;
		private var _config:Object;
		private var _curPlayIndex:int = -1;
		private var timer:Timer;
		  
		public function CardManager(cards:Array, player:CardPlayer) {
			_cards = cards;
			_player = player;
			
			CONFIG::release {
				timer = new Timer(500);
				timer.addEventListener(TimerEvent.TIMER, checkJSAvailable);
				timer.start();
				checkJSAvailable();
			}
			CONFIG::debug {
				flv_setWonhot(null);
			}
		}
		
		private function checkJSAvailable(evt:TimerEvent = null):void {
			if (ExternalInterface.available) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, checkJSAvailable);
				timer = null;
				addCallback();
			}
		}
		
		private function addCallback():void {
			//Util.log("addCallback");
			ExternalInterface.addCallback("flv_setWonhot", this.flv_setWonhot);
		}
		
		public function flv_setWonhot(config:Object):void {
			Util.log("flv_setWonhot:" + config);
			CONFIG::release {
				_config = config;
			}
			CONFIG::debug {
				_config = {
					"data":[{
						"fileSrc":"http://biz5.sandai.net/portal/image/40/o1460713240940.flv",
						"imgSrc":"http://biz5.sandai.net/portal/image/58/o1460713241058.jpg",
						"fileLink":"http://count.cpm.cm.sandai.net/UClick?gs=cmGeneral&position=2909&entryid=WHT01&location=http%3A%2F%2Fwww.qq.com",
						"title":"网站首页万花筒01--2909-test"
					  }, {
						"fileSrc":"http://biz5.sandai.net/portal/image/61/o1460713240961.flv",
						"imgSrc":"http://biz5.sandai.net/portal/image/66/o1460713241066.jpg",
						"fileLink":"http://count.cpm.cm.sandai.net/UClick?gs=cmGeneral&position=2909&entryid=WHT02&location=http%3A%2F%2Fwww.baidu.com",
						"title":"网站首页万花筒02--2909-test"
					  }, {
						"fileSrc":"http://biz5.sandai.net/portal/image/83/o1460713240983.flv",
						"imgSrc":"http://biz5.sandai.net/portal/image/78/o1460713241078.jpg",
						"fileLink":"http://count.cpm.cm.sandai.net/UClick?gs=cmGeneral&position=2909&entryid=WHT03&location=http%3A%2F%2Fwww.sina.com",
						"title":"网站首页万花筒03--2909-test"
					  }, {
						"fileSrc":"http://biz5.sandai.net/portal/image/07/o1460713241007.flv",
						"imgSrc":"http://biz5.sandai.net/portal/image/85/o1460713241085.jpg",
						"fileLink":"http://count.cpm.cm.sandai.net/UClick?gs=cmGeneral&position=2909&entryid=WHT04&location=http%3A%2F%2Fwww.hao123.com",
						"title":"网站首页万花筒04--2909-test"
					  }, {
						"fileSrc":"http://biz5.sandai.net/portal/image/26/o1460713241026.flv",
						"imgSrc":"http://biz5.sandai.net/portal/image/98/o1460713241098.jpg",
						"fileLink":"http://count.cpm.cm.sandai.net/UClick?gs=cmGeneral&position=2909&entryid=WHT05&location=http%3A%2F%2Fwww.kankan.com",
						"title":"网站首页万花筒05--2909-test"
					  }, {
						"fileSrc":"http://biz5.sandai.net/portal/image/44/o1460713241044.flv",
						"imgSrc":"http://biz5.sandai.net/portal/image/05/o1460713241105.jpg",
						"fileLink":"http://count.cpm.cm.sandai.net/UClick?gs=cmGeneral&position=2909&entryid=WHT06&location=http%3A%2F%2Fwww.youku.com",
						"title":"网站首页万花筒06--2909-test"
					  }],
					"packageUrl": "http://click.cm.sandai.net/UClick?gs=cmuclick&ad=1460445249748&position=2909&materialid=m13117497",
					"startPv":"http://pv.cm.sandai.net/UPV?gs=cmupvEnhance&pvkey=2909&materialid=m13117497",
					"startLink":"http://www.baidu.com/startlink.2909"
				};
			}
			
			var data:Array = _config.data || [];
			for (var i:int = 0, len:int = data.length; i < len; i++) {
				_cards[i].title = data[i].title || "";
				_cards[i].pic = data[i].imgSrc || "";
			}
		}
		
		public function fire_expand():void {
			ExternalInterface.available && ExternalInterface.call("flv_wonhotEvent", "expand");
		}
		
		public function fire_collapse():void {
			ExternalInterface.available && ExternalInterface.call("flv_wonhotEvent", "collapse");
		}
		
		public function playMedia(index:int = 0):void {
			if (_config && _config.data && _config.data[index]) {
				if (_curPlayIndex != -1) {
					_cards[_curPlayIndex].play = false;
				}
				_curPlayIndex = index;
				_player.link = _config.data[index].fileLink;
				_player.connectStream(_config.data[index].fileSrc || "");
				_cards[index].play = true;
			}
		}
		
		public function closeMedia():void {
			_player.clear();
			if (_curPlayIndex != -1) {
				_cards[_curPlayIndex].play = false;
			}
			_curPlayIndex = -1;
		}
		
		public function get curPlayIndex():int {
			return _curPlayIndex;
		}
	}
}