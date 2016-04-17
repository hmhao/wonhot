package com.xl.wonhot {
	import com.xl.ui.wonhot.UICard;
	import com.xl.wonhot.interfaces.ICard;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	
	/**
	 * 卡片
	 * @author hmh
	 */
	public class Card extends Sprite implements ICard{
		private var _card:UICard;
		private var _btn:SimpleButton;
		private var _title:TextField;
		private var _picLoader:Sprite;
		private var _loader:Loader;
		
		protected var _index:int = -1;//编号
		protected var _reflection:CardReflection;//翻转影子
		
		public function Card() {
			this.init();
		}
		
		protected function init():void {
			_card = new UICard();
			_btn = _card.getChildByName("btn") as SimpleButton;
			_title = _card.getChildByName("title") as TextField;
			_picLoader = _card.getChildByName("picLoader") as Sprite;
			this.addChild(_card);
			this.buttonMode = true;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, picLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, picLoadErr);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, picLoadErr);
			_picLoader.addChild(_loader);
		}
		
		private function picLoadComplete(evt:Event):void {
			Util.log(evt);
			_loader.width = _picLoader.width;
			_loader.height = _picLoader.height;
			_reflection && _reflection.update();
		}
		
		private function picLoadErr(evt:Event):void {
			Util.log(evt);
		}
		
		private function updatePosition():void {
			if (_reflection) {
				if (_reflection.axis == CardReflection.AXIS_X) {
					_reflection.x = this.x;
					_reflection.y = this.y + this.height;
				}else if (_reflection.axis == CardReflection.AXIS_Y) {
					_reflection.x = this.x + this.width;
					_reflection.y = this.y;
				}else {
					_reflection.x = this.x;
					_reflection.y = this.y;
				}
			}
		}
		
		public function set title(value:String):void {
			_title.text = value;
		}
		
		public function set pic(value:String):void {
			_loader.load(new URLRequest(value));
		}
		
		public function set play(value:Boolean):void {
			_btn.visible = !value;
		}
		
		public function set index(value:int):void {
			_index = value;
		}
		
		public function get index():int {
			return _index;
		}
		
		public function set reflection(obj:CardReflection):void {
			_reflection = obj;
			this.updatePosition();
		}
		
		public function get reflection():CardReflection {
			return _reflection;
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			this.updatePosition();
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			this.updatePosition();
		}
	}
}