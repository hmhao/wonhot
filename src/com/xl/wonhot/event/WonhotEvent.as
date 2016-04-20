package com.xl.wonhot.event {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author hmh
	 */
	public class WonhotEvent extends Event {
		public static const CLOSE:String = "close";
		public static const LINK:String = "link";
		public static const EXPAND:String = "expand";
		public static const COLLAPSE:String = "collapse";
		
		public function WonhotEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}