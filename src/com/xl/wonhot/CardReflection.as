package com.xl.wonhot {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * 卡片影子，用于翻转
	 * @author hmh
	 */
	public class CardReflection extends Sprite{
		public static const AXIS:int = 0;
		public static const AXIS_X:int = 1;
		public static const AXIS_Y:int = 2;
		
		private var _axis:int = AXIS;
		private var _entity:DisplayObject;
		private var _bm:Bitmap = new Bitmap();
		
		public function CardReflection(obj:DisplayObject, axis:int = 0) {
			_entity = obj;
			_axis = axis;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.addChild(_bm);
			this.update();
		}
		
		public function update():void {
			if (!_entity) return;
			
			var x:Number = 0, y:Number = 0, scaleX:Number = 1, scaleY:Number = 1;
			switch(_axis) {
				case AXIS_X:x = 0; y = _entity.height; scaleY = -1; break;
				case AXIS_Y:x = _entity.width; y = 0; scaleX = -1; break;
			}
			var bmd:BitmapData = new BitmapData(_entity.width, _entity.height);
			bmd.draw(_entity);
			_bm.bitmapData = bmd;
			_bm.scaleX = scaleX;
			_bm.scaleY = scaleY;
			_bm.x = x;
			_bm.y = y;
		}
		
		public function get axis():int {
			return _axis;
		}
	}
}