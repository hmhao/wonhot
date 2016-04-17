package com.xl.wonhot {
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author hmh
	 */
	public class CardManager extends EventDispatcher {
		private var _cards:Array;
		private var _player:CardPlayer;
		
		public function CardManager(cards:Array, player:CardPlayer) {
			_cards = cards;
			_player = player;
		}
	
	}

}