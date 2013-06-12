package jp.tp.qlclock.model.proxy
{
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ConfigProxy extends Proxy
	{
		//name
		public static const NAME:String = "ConfigProxy";
		//notes
		public static const UPDATE_BOUNDS:String = NAME + "/updateBounds";
		public static const INIT_BOUNDS:String = NAME + "/initBounds";
		
		private var so:SharedObject;
		private var _bounds:Rectangle;
		
		public function ConfigProxy()
		{
			super(NAME);
		}

		private var _defaultBounds:Rectangle = new Rectangle(100, 100, 320, 180);
		public function get defaultBounds():Rectangle
		{
			return _defaultBounds.clone();
		}


		override public function onRegister():void
		{
			so = SharedObject.getLocal("conf");
			
			var b:Object = so.data.bounds;
			if(b && b.x && b.y && b.width && b.height)
			{
				_bounds = new Rectangle(b.x, b.y, b.width, b.height);
			}
			else
			{
			}
		}
		override public function onRemove():void
		{
			
		}
		public function save():void
		{
			so.flush();
		}		
		public function get bounds():Rectangle
		{
			return _bounds;
		}
		
		public function set bounds(value:Rectangle):void
		{
			_bounds = value;
			so.data.bounds = value;
			save();
			sendNotification(UPDATE_BOUNDS, bounds);
		}
	}
}