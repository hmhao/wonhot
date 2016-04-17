package com.xl.wonhot {
	import com.xl.wonhot.Card;
	import com.xl.wonhot.event.WonhotEvent;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author hmh
	 */
	public class Wonhot extends Sprite {
		public const CLOSEED:int = 1;
		public const CLOSEING:int = 2;
		public const OPENING:int = 3;
		public const OPENED:int = 4;
		
		private var timer:Timer = new Timer(500, 1);//右侧底部card hover间隔expand
		private var status:int = CLOSEED;//展示状态
		private var mode:int = 4;//大屏和小屏，右侧card 4个，中屏右侧card 6个
		private var total:int = 6;//右侧card总数6个
		private var margin:int = 17;//card间距
		private var cardArr:Array = [];//card数组
		private var cardPlayer:CardPlayer;//播放器
		
		public function Wonhot() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var sw:Number = stage.stageWidth,
				sh:Number = stage.stageHeight,
				i:int = 0,
				card:Card, reflection:CardReflection;
			
			//初始化card
			for (i = 0; i < total; i++) {
				card = new Card();
				card.x = sw - (int(i / 2) + 1) * card.width - int(i / 2) * margin;
				card.y = sh - (i % 2 + 1) * card.height - (i % 2) * margin;
				card.visible = false;
				cardArr.push(card);
				this.addChild(card);
			}
			//初始化翻转
			for (i = 1; i < total; i++) {
				card = cardArr[i];
				if (i == 1) {
					reflection = new CardReflection(card, CardReflection.AXIS_X);
				}else {
					reflection = new CardReflection(card, CardReflection.AXIS_Y);
				}
				card.reflection = reflection;//会根据AXIS自动调整位置
				reflection.visible = false;
				this.addChild(reflection);
			}
			//初始化播放器
			cardPlayer = new CardPlayer();
			cardPlayer.x = sw - cardPlayer.width - (mode / 2) * (cardArr[0].width + margin);
			cardPlayer.y = sh - cardPlayer.height;
			cardPlayer.visible = false;
			reflection = new CardReflection(cardPlayer, CardReflection.AXIS_Y);
			reflection.visible = false;
			cardPlayer.reflection = reflection;
			this.addChild(cardPlayer);
			this.addChild(reflection);
			
			cardArr[0].visible = true;
			cardArr[0].addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			cardArr[0].addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			cardPlayer.addEventListener(WonhotEvent.CLOSE, onClose);
			cardPlayer.addEventListener(WonhotEvent.LINK, onLink);
			timer.addEventListener(TimerEvent.TIMER, onStart);
			stage.addEventListener(Event.RESIZE, updatePosition);
		}
		
		private function updatePosition(evt:Event = null):void {
			var sw:Number = stage.stageWidth,
				card:Card;
				
			if (sw < 1180 || sw > 1420) {
				mode = 4;
			} else {
				mode = 6;
			}
			for (var i:int = 0; i < total; i++) {
				card = cardArr[i];
				card.x = sw - (int(i / 2) + 1) * card.width - int(i / 2) * margin;
				if (status == OPENED || status == OPENING) {
					card.visible = i < mode;
				}else {
					card.visible = i == 0 || card.visible;
				}
			}
			
			cardPlayer.x = sw - cardPlayer.width - (mode / 2) * (cardArr[0].width + margin);
			cardPlayer.visible = status == OPENED;
		}
	
		private function onMouseRollOver(evt:MouseEvent):void {
			if (status == CLOSEED) {
				trace("start:" + status);
				timer.start();
			}
		}
		
		private function onMouseRollOut(evt:MouseEvent):void {
			if (status == CLOSEED) {
				trace("reset:" + status);
				timer.reset();
			}
		}
		
		private function onStart(evt:TimerEvent):void {
			startExpand();
		}
		
		private function onClose(evt:WonhotEvent):void {
			startCollapse();
		}
		
		private function onLink(evt:WonhotEvent):void {
			//跳转
		}
		
		private function startExpand():void {
			status = OPENING;
			trace("expand:status" + status);
			expand(0);
		}
		
		private function completeExpand():void {
			status = OPENED;
			trace("expand:status" + status);
			//播放
		}
		
		private function startCollapse():void {
			status = CLOSEING;
			trace("collapse:status" + status);
			collapse(0);
		}
		
		private function completeCollapse():void {
			status = CLOSEED;
			trace("collapse:status" + status);
			timer.reset();
		}
		
		private function expand(round:int = 0):void {
			trace("expand:round" + round);
			if (round == 0) {
				doExpand(cardArr.slice(1,2), 0.5, { alpha:1, rotationX: -180, onComplete:expand, onCompleteParams:[round + 1] });
			}else if (round == 1) {
				doExpand(cardArr.slice(2,4), 0.5, { alpha:1, rotationY: 180, onComplete:expand, onCompleteParams:[round + 1] });
			}else if (round == 2) {
				if (mode == 4) {
					doExpand(cardArr.slice(4,6), 0, { alpha:1, rotationY: 180, onComplete:expand, onCompleteParams:[round + 1]});
				}else {
					doExpand(cardArr.slice(4,6), 0.5, { alpha:1, rotationY: 180, onComplete:expand, onCompleteParams:[round + 1]});
				}
			} else if (round == 3) {
				doExpand([cardPlayer], 0.5, { alpha:1, rotationY: 180, onComplete:completeExpand});
			}
		}
		
				
		private function collapse(round:int = 0):void {
			trace("collapse:round" + round);
			if (round == 0) {
				doCollapse([cardPlayer], 0.5, { alpha:0, rotationY: 0, onComplete:collapse, onCompleteParams:[round + 1] } );
			}else if (round == 1) {
				if (mode == 4) {//若原展开6个card，后改变长度使2个card隐藏，需要将这2个card收回去
					doCollapse(cardArr.slice(4, 6), 0, { alpha:0, rotationY: 0, onComplete:collapse, onCompleteParams:[round + 1] } );
				}else {
					doCollapse(cardArr.slice(4, 6), 0.5, { alpha:0, rotationY: 0, onComplete:collapse, onCompleteParams:[round + 1] } );
				}
			}else if (round == 2) {
				doCollapse(cardArr.slice(2,4), 0.5, { alpha:0, rotationY: 0, onComplete:collapse, onCompleteParams:[round + 1] });
			}else if (round == 3) {
				doCollapse(cardArr.slice(1,2), 0.5, { alpha:0, rotationX: 0, onComplete:completeCollapse} );
			}
		}
		
		private function doExpand(cards:Array, duration:Number, vars:Object):void {
			doFlip(cards, duration, vars || { }, "expand");
		}
		
		private function doCollapse(cards:Array, duration:Number, vars:Object):void {
			doFlip(cards, duration, vars || { }, "collapse");
		}
		
		private function doFlip(cards:Array, duration:Number, vars:Object, type:String):void {
			var card:Card, 
				len:int = cards.length,
				count:int = len,
				_onComplete: Function,//缓存vars中的onComplete
				_onCompleteParams:Array,//缓存vars中的onCompleteParams
				onComplete: Function = function(card:Card):void {
					if (type == "expand") {
						card.visible = duration !=0 && true;//显示card
					}else {
						card.visible = false;//隐藏card
					}
					card.reflection.visible = false;//隐藏影子
					if (--count <= 0) {
						_onComplete && _onComplete.apply(this, _onCompleteParams);
					}
				};
				
			if (vars.onComplete) {
				_onComplete = vars.onComplete;
			}
			if (vars.onCompleteParams) {
				_onCompleteParams = vars.onCompleteParams;
			}
			
			for (var i:int = 0, $vars:Object; i < len; i++) {
				card = cards[i];
				if (type == "expand") {
					card.reflection.alpha = 0;//影子透明0
				}else {
					card.reflection.alpha = 1;//影子透明1
				}
				card.visible = false;//隐藏card
				card.reflection.visible = true;//显示影子
				$vars = clone(vars);
				$vars.onComplete = onComplete;
				$vars.onCompleteParams = [card];
				TweenLite.to(card.reflection, duration, $vars);
			}
		}
		
		public function clone(obj:Object):* {
            var copier:ByteArray = new ByteArray();
            copier.writeObject(obj);
            copier.position = 0;
            return copier.readObject();
		}
	}
}