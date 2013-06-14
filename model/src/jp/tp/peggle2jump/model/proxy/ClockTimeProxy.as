package jp.tp.peggle2jump.model.proxy
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ClockTimeProxy extends Proxy
	{
		//name
		public static const NAME:String = "ClockTimeProxy";
		//notes
		public static const TIME_UPDATE:String = NAME + "/timeUpdate";
		public static const HOUR_UPDATE:String = NAME + "/hourUpdate";
		public static const MINUTE_UPDATE:String = NAME + "/minuteUpdate";
	
		//props
		private var _timer:Timer;
		//時刻チェック間隔(ms) 0-60sec
		private var _checkInterval:Number = 10 * 1000;
		private var _date:Date;
		
		public function get date():Date
		{
			return new Date(_date.time);
		}
		
		public function ClockTimeProxy()
		{
			super(NAME);
		}
		override public function onRegister():void
		{
			//init
			_date = new Date();
			_timer = new Timer(nextTime());
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}
		override public function onRemove():void
		{
			
		}
		private function timerHandler(e:TimerEvent):void
		{
			updateTime();
			_timer.delay = nextTime();
		}
		/**
		 * 現在時刻を更新する
		 * 
		 * 時分が更新されていれば通知する
		 */ 
		private function updateTime():void
		{
			var now:Date = new Date();
			var diffMS:Number = now.time - _date.time;
			
			//レジューム復帰時にはちょうどn時間、n日後で同じminute/hourが入る可能性があるので差分も確かめる
			if((now.minutes != _date.minutes) || (diffMS >= 60000))
			{
				sendNotification(MINUTE_UPDATE);
			}
			if((now.hours != _date.hours) || (diffMS >= 3600000))
			{
				//ゼロ分台のときだけ通知（復帰時2:50->3:05などのタイミングでは通知しない）
				if(now.minutes == 0)
				{
					sendNotification(HOUR_UPDATE);
				}
			}
//			sendNotification(TIME_UPDATE);
			_date = now;
		}
		/**
		 * 次回確認時刻までをmsで返す
		 */ 
		private function nextTime():Number
		{
			return _checkInterval - _date.time % _checkInterval;
		}
	}
}