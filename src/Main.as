
/*
 * This file is part of the Proton distribution (https://github.com/KrzysztofSzewczyk/Proton).
 * Copyright (c) 2019 Krzysztof Palaiologos Szewczyk.
 * 
 * This program is free software: you can redistribute it and/or modify  
 * it under the terms of the GNU General Public License as published by  
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * A little bit pumped up version of classic "Hello World" application.
 * It's displaying colorful Hello World text on the middle of stage, and
 * blinking bar of pipes in random colors, changing every 10ms.
 */

package {
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Main {
		/* Private variables: parent MovieClip and tiemr updating pipes. */
		private var parent:MovieClip;
		private var updateTimer:Timer;
		
		/* Bar out of pipes to be displayed. */
		
		private const BAR:String = "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||";
		
		/* Rainbow-generation algo */
		
		private function sin_to_hex(i:int, phase:int, size:int):String {
			var hex:String = (Math.floor(Math.sin(Math.PI / size * 2 * i + phase) * 127) + 128).toString(16);
			
			return hex.length == 1 ? "0" + hex : hex;
		}

		/* This function is colouring up the "Hello, World" string. */

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
		
		/* This function is colouring up the bar in random colors. */
		
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
		
		/* Timer tick event, changing pipes color. Note htmlText usage! */
		
		private function onTimer(e:TimerEvent):void {
			parent.RainbowTxt.htmlText = colorfulRandom(BAR);
		}
		
		/* Constructor code, taking instance as parent MovieClip, and setting up bar,
		   message and update timer. */
		
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
