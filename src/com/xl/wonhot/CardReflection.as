package com.xl.wonhot {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author hmh
	 */
	public class CardReflection extends Sprite{
		public static const AXIS:int = 0;
		public static const AXIS_X:int = 1;
		public static const AXIS_Y:int = 2;
		
		private var _axis:int = AXIS;
		private var _bm:Bitmap = new Bitmap();
		
		public function CardReflection(obj:DisplayObject, axis:int = 0) {
			_axis = axis;
			var x:Number = 0, y:Number = 0, scaleX:Number = 1, scaleY:Number = 1;
			switch(axis) {
				case AXIS_X:x = 0; y = obj.height; scaleY = -1; break;
				case AXIS_Y:x = obj.width; y = 0; scaleX = -1; break;
			}
			var bmd:BitmapData = new BitmapData(obj.width, obj.height);
			bmd.draw(obj);
			_bm.bitmapData = bmd;
			_bm.scaleX = scaleX;
			_bm.scaleY = scaleY;
			_bm.x = x;
			_bm.y = y;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.addChild(_bm);
		}
		
		public function get axis():int {
			return _axis;
		}
	}
}