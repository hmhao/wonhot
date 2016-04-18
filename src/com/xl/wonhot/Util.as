package com.xl.wonhot {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author hmh
	 */
	public class Util {
		
		public static function clone(obj:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(obj);
			copier.position = 0;
			return copier.readObject();
		}
		
		/**
		 * extend(target,opt1,opt2...)
		 * extend(true,target,opt1,opt2...)
		 * */
		public static function extend(...rest):Object {
			var options:Object, name:String, src:Object, copy:Object,
				target:* = rest[0] || {}, // 目标对象  
				i:int = 1,  
				length:int = rest.length,  
				isnew:Boolean = false;
				
			// 是否创建新的目标对象(第一个参数是boolean类型且为true)
			if ( typeof target === "boolean" ) {  
				isnew = target;
				target = rest[1] || { };
				if (isnew) {
					target = clone(target);
				}
				// 跳过第一个参数(是否创建新的目标对象)和第二个参数(目标对象)
				i = 2;  
			}  
			// 如果目标不是对象或函数，则初始化为空对象  
			if ( typeof target !== "object" ) {  
				target = {};  
			}  
			for (; i < length; i++ ) {  
				// Only deal with non-null/undefined values  
				if ( (options = rest[ i ]) != null ) {  
					// Extend the base object  
					for ( name in options ) {  
						src = target[ name ];
						copy = options[ name ];
						// Prevent never-ending loop  
						if ( target === copy ) {  
							continue;  
						}  
						if ( typeof copy !== "undefined") {  
							target[ name ] = copy;  
						}  
					}  
				}  
			}  
			// 返回已经被修改的对象  
			return target;  
		}
		
		public static function windowOpen(str:String):void {
			if (!/https?:\/\//.test(str)) { return; }
			navigateToURL(new URLRequest(str));
		}
		
		public static function log(...rest):void {
			CONFIG::release {
				ExternalInterface.available && ExternalInterface.call("console.log", rest);
			}
			CONFIG::debug {
				trace(rest);
			}
		}
	}

}