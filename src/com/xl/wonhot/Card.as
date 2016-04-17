package com.xl.wonhot {
	import com.xl.ui.wonhot.UICard;
	import com.xl.wonhot.interfaces.ICard;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author hmh
	 */
	public class Card extends Sprite implements ICard{
		private var _card:UICard;
		private var _title:TextField;
		private var _picLoader:Sprite;
		
		protected var _reflection:CardReflection;//翻转影子
		
		public function Card() {
			this.init();
		}
		
		protected function init():void {
			_card = new UICard();
			_title = _card.getChildByName("title") as TextField;
			_picLoader = _card.getChildByName("picLoader") as Sprite;
			this.addChild(_card);
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
	}
}