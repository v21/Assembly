package v21.assembly
{

	public class ColorHSL {
		
		public static const red : int = 0xFF0000;
		public static const green : int = 0x00FF00;
		public static const blue : int = 0x0000FF;
		public static const black : int = 0x000000;
		public static const white : int = 0xFFFFFF;
		public static const grey : int = 0x808080;
		public static const yellow : int = 0xFFFF00;
		
				/**
		 * Linear interpolation between two values.
		 * @param	a		First value.
		 * @param	b		Second value.
		 * @param	t		Interpolation factor.
		 * @return	When t=0, returns a. When t=1, returns b. When t=0.5, will return halfway between a and b. Etc.
		 */
		public static function numLerp(a:Number, b:Number, t:Number = 1):Number
		{
			return a + (b - a) * t;
		}
		/**
		 * Clamps the value within the minimum and maximum values.
		 * @param	value		The Number to evaluate.
		 * @param	min			The minimum range.
		 * @param	max			The maximum range.
		 * @return	The clamped value.
		 */
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			if (max > min)
			{
				value = value < max ? value : max;
				return value > min ? value : min;
			}
			value = value < min ? value : min;
			return value > max ? value : max;
		}
		
		/**
		 * Linear interpolation between two angles. They wrap over the value 360.
		 * @param	a		First angle.
		 * @param	b		Second angle.
		 * @param	t		Interpolation factor.
		 * @return	When t=0, returns a. When t=1, returns b. When t=0.5, will return halfway between a and b. Etc.
		 */
		public static function angleLerp(a:Number, b:Number, t:Number = 1):Number
		{
			
			var num : Number = (b - a) - Math.floor((b - a) / 360) * 360;
			
			if (num > 180)
			{
				num -= 360;
			}
			return (a + num * clamp(t, 0, 1) + 360) % 360;
		}
		
		public static function random () : int {
			return ( (int)(Math.random() * 0xFFFFFF));
		}
		
		public var h : Number;
		public var s : Number;
		public var l : Number;
		
		public static function lerpInt(a : uint, b : uint, t: uint) : uint
		{
			return lerp(fromInt(a), fromInt(b), t).int;
		}
		
		public static function lerp(a : ColorHSL, b : ColorHSL, t : Number) : ColorHSL
		{
			
			var c : ColorHSL = new ColorHSL();
			
			//check special case black (color.b==0): interpolate neither hue nor saturation!
			//check special case grey (color.s==0): don't interpolate hue!
			if (a.l == 0)
			{
				c.h=b.h;
				c.s=b.s;
			}
			else if(b.l==0){
				c.h=a.h;
				c.s=a.s;
			}
			else{
				if(a.s==0){
					c.h =b.h;
				}else if(b.s==0){
					c.h=a.h;
				}else{
					c.h = angleLerp(a.h, b.h, t);
				}
				c.s=numLerp(a.s,b.s,t);
			}
			c.l = numLerp(a.l, b.l, t);
			
			return c;
		}
		
		public static function fromHSL(h : Number, s : Number, l : Number) : ColorHSL
		{
			var c : ColorHSL = new ColorHSL();
			c.h = h;
			c.s = s;
			c.l = l;
			return c;
		}
		
		public static function fromInt(color : uint) : ColorHSL
		{
			var c : ColorHSL = new ColorHSL();
			c.int = color;
			return c;
		}
		
		public function set int(color: uint) : void
		{
				
			var r:Number = (color >> 16) / 255, 
				g:Number = (color >> 8 & 0xFF) / 255, 
				b:Number = (color & 0xFF) / 255,
				min:Number = Math.min(Math.min(r, g), b),
				max:Number = Math.max(Math.max(r, g), b);
			
			l = (max + min) / 2;
			if (max == min) {
				s = 0;
				h = Number.NaN;
			} else {
				if (l < .5) {
					s = (max - min) / (max + min);
				} else {
					s = (max - min) / (2 - max - min);
				}
			}
			if (r == max) h = (g - b) / (max - min);
			else if (g == max) h = 2 + (b - r) / (max - min);
			else if (b == max) h = 4 + (r - g) / (max - min);
			
			h /= 6;
			if (h < 0) h += 1;
		
		}
		
		public function get int () :uint
		{
			var r : Number, g : Number, b : Number;
			var t1:Number, t2:Number, t3:Array = [0,0,0], c:Array = [0,0,0];
			if (l < .5) {
				t2 = l * (1 + s);
			} else {
				t2 = l + s - l * s;
			}
			t1 = 2 * l - t2;
			t3[0] = h + 1 / 3;
			t3[1] = h;
			t3[2] = h - 1 / 3;
			for (var i:uint = 0; i < 3; i++) {
				if (t3[i] < 0) t3[i] += 1;
				if (t3[i] > 1) t3[i] -= 1;
				
				if (6 * t3[i] < 1) c[i] = t1 + (t2 - t1) * 6 * t3[i];
				else if (2 * t3[i] < 1) c[i] = t2;
				else if (3 * t3[i] < 2) c[i] = t1 + (t2 - t1) * ((2 / 3) - t3[i]) * 6;
				else c[i] = t1;
			}
			r = c[0] * 255;
			g = c[1] * 255;
			b = c[2] * 255;
			return (r << 16 | g << 8 | b);
		
		}
		
	}


}