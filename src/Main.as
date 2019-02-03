package {
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Main {
		private var parent:MovieClip;
		private var updateTimer:Timer;
		
		private const BAR:String = "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||";
		
		private function sin_to_hex(i:int, phase:int, size:int):String {
			var hex:String = (Math.floor(Math.sin(Math.PI / size * 2 * i + phase) * 127) + 128).toString(16);
			
			return hex.length == 1 ? "0" + hex : hex;
		}
		
		private function colorful(s:String):String {
			var size:int = s.length;
			var rainbow:Array = new Array(size);
			var ret:String = '';
			
			for (var i:int = 0; i < size; i++) {
				var red:String = sin_to_hex(i, 0 * Math.PI * 2/3, size);
				var blue:String = sin_to_hex(i, 1 * Math.PI * 2/3, size);
				var green:String = sin_to_hex(i, 2 * Math.PI * 2/3, size);
			
				rainbow[i] = "#" + red + green + blue;
			}
			
			for(var i2:int = 0; i2 < size; i2++) {
				ret += "<font color='" + rainbow[i2] + "'>" + s.charAt(i2) + "</font>"
			}
			
			return ret;
		}
		
		private function colorfulRandom(s:String):String {
			var size:int = s.length;
			var rainbow:Array = new Array(size);
			var ret:String = '';
			
			for (var i:int = 0; i < size; i++) {
				var red:String = Math.floor(Math.random() * 1000 % 255).toString(16);
				var green:String = Math.floor(Math.random() * 1000 % 255).toString(16);
				var blue:String = Math.floor(Math.random() * 1000 % 255).toString(16);
				if(red.length == 1)
					red = "0" + red;
				if(green.length == 1)
					green = "0" + green;
				if(blue.length == 1)
					blue = "0" + blue;
				rainbow[i] = "#" + red + green + blue;
			}
			
			for(var i2:int = 0; i2 < size; i2++) {
				ret += "<font color='" + rainbow[i2] + "'>" + s.charAt(i2) + "</font>"
			}
			
			return ret;
		}
		
		private function onTimer(e:TimerEvent):void {
			parent.RainbowTxt.htmlText = colorfulRandom(BAR);
		}
		
		public function Main(instance:MovieClip) {
			parent = instance;
			parent.HelloTxt.htmlText = colorful("Hello, world!");
			parent.RainbowTxt.htmlText = colorful(BAR);
			updateTimer = new Timer(10);
            updateTimer.addEventListener(TimerEvent.TIMER, onTimer);
            updateTimer.start();
		}
	}
}
