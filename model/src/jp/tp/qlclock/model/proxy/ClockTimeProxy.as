package jp.tp.qlclock.model.proxy
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ClockTimeProxy extends Proxy
	{
		//name
		public static const NAME:String = "ClockTimeProxy";
		//notes
		public static const TIME_UPDATED:String = NAME + "/timeUpdated";
	
		//props
		private var _timer:Timer;
		
		public function ClockTimeProxy()
		{
			super(NAME);
		}
		override public function onRegister():void
		{
			//init
			_timer = new Timer(nextTime());
			
			_timer.addEventListener(TimerEvent.TIMER, hourTimerHandler);
			_timer.start();
		}
		override public function onRemove():void
		{
			
		}
		public function hourTimerHandler(e:TimerEvent):void
		{
			_timer.delay = nextTime();
			sendNotification(TIME_UPDATED);
		}
		/**
		 * 次回アラームをmsで返す
		 */ 
		private function nextTime():Number
		{
			var date:Date = new Date();
			return (3600 - date.minutes * 60 - date.seconds) * 1000;
		}
	}
}