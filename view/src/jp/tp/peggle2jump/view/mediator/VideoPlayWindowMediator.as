package jp.tp.peggle2jump.view.mediator
{
	import a24.tween.Ease24;
	import a24.tween.Tween24;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import jp.tp.peggle2jump.controller.constant.AppConstants;
	import jp.tp.peggle2jump.model.proxy.ClockTimeProxy;
	import jp.tp.peggle2jump.view.component.VideoWindow;
	import jp.tp.peggle2jump.view.event.FlexNativeWindowEvent;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaPlayerState;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.VideoDisplay;
	
	public class VideoPlayWindowMediator extends Mediator
	{
		public static const NAME:String = "VideoPlayWindowMediator";
		
		public function VideoPlayWindowMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			//evt
			view.video.addEventListener(TimeEvent.COMPLETE, onVideoComplete);
			view.video.addEventListener(MouseEvent.MOUSE_DOWN, onVideoMouseDown);
			view.video.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
			view.addEventListener(Event.CLOSING, onWindowClosing);
			view.addEventListener(FlexNativeWindowEvent.DRAG_MOVE, onWindowMove);
			
			//set context menu
//			view.container.contextMenu = initMenu();
			
			//appearance
			view.container.caption.visible = false;
			view.container.preview.visible = false;
			
				
			//windowsの透明窓だとコンテナのwidthが正しく設定されないようなのでここで時刻のfontsizeを設定する
			view.container.clock.setStyle("fontSize", view.width * 0.2);
			
		}
		override public function onRemove():void
		{
			view.video.stop();
			view.video.removeEventListener(TimeEvent.COMPLETE, onVideoComplete);
			view.video.removeEventListener(MouseEvent.MOUSE_DOWN, onVideoMouseDown);
			view.video.removeEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
			view.removeEventListener(Event.CLOSING, onWindowClosing);
			view.removeEventListener(FlexNativeWindowEvent.DRAG_MOVE, onWindowMove);
		}
		override public function listNotificationInterests():Array
		{
			return [
				AppConstants.CLOSE_VIDEO,
				ClockTimeProxy.MINUTE_UPDATE
			];
		}
		override public function handleNotification(n:INotification):void
		{
			switch(n.getName())
			{
				case AppConstants.CLOSE_VIDEO:
//					close();
					break;
				case ClockTimeProxy.MINUTE_UPDATE:
					updateClock();
					break;
			}
		}	
		private function get view():VideoWindow
		{
			return viewComponent as VideoWindow;
		}		
		private function updateClock():void
		{
			view.container.date = new Date();
		}
		private function onVideoMouseDown(e:MouseEvent):void
		{
			view.startDrag();
		}
		private function onDurationChange(e:TimeEvent):void
		{
			if(isNaN(e.time)) return;
			view.video.removeEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
			play();
		}
		private function play():void
		{
			var b:Rectangle = view.bounds;
			var startX:Number;
			var screenWidth:Number = Capabilities.screenResolutionX;
			var screenHeight:Number = Capabilities.screenResolutionY;
			var dur:Number = view.video.duration;
			startX = (b.x < (screenWidth - b.width) / 2) ? 0 : screenWidth - b.width;
			
			Tween24.parallel(
				Tween24.serial(
					Tween24.prop(view).x(startX).y(screenHeight),
					Tween24.prop(view.container).fadeOut(),
					Tween24.parallel(
						Tween24.tween(view,1.5, Ease24._4_QuartOut).y(screenHeight-view.height),
						Tween24.tween(view.container,1.0, Ease24._2_QuadOut).fadeIn()
					),
					Tween24.wait(.4),
					Tween24.tween(view,0.25, Ease24._1_SineOut).y(screenHeight - b.height*2/3),
					Tween24.wait(.1),
					Tween24.parallel(
						Tween24.tween(view,1.2, Ease24._1_SineOut).x(b.x),
						Tween24.tween(view,1.2, Tween24.ease.BackOut).y(b.y)
					),
					Tween24.wait(dur-1.5-0.4-0.25-0.1-1.2-0.5),
					Tween24.tween(view.container,0.5, Ease24._2_QuadIn).fadeOut()
				),
				Tween24.serial(
					Tween24.prop(view.container.clock).fadeOut(),
					Tween24.wait(4.135),
					Tween24.tween(view.container.clock, 1.0, Ease24._1_SineIn).fadeIn()
				)
			).play();
			
			view.video.play();
			view.activate();			
		}
		private function onVideoComplete(e:TimeEvent):void
		{
			closeView();
		}
		/**
		 * mediator側からviewをcloseする
		 */ 
		private function closeView():void
		{
			removeMediator();
			view.close();
		}
		/**
		 * 外部からviewがcloseされたとき
		 */ 
		private function onWindowClosing(e:Event):void
		{
			removeMediator();
		}
		private function removeMediator():void
		{
			facade.removeMediator(NAME);
		}
		private function onWindowMove(e:FlexNativeWindowEvent):void
		{
			var v:VideoDisplay = view.video;
			var pt:Point = view.globalToScreen(new Point(v.x, v.y));
			sendNotification(AppConstants.SAVE_BOUNDS, new Rectangle(pt.x, pt.y, v.width, v.height));
		}
		private var quitMenu:NativeMenuItem = new NativeMenuItem("Close");
		private var restoreMenu:NativeMenuItem = new NativeMenuItem("Set size and position");
		private function initMenu():NativeMenu
		{
			restoreMenu.addEventListener(Event.SELECT, onSelectInit);
			quitMenu.addEventListener(Event.SELECT, onSelectQuit);
			
			var menu:NativeMenu = new NativeMenu();
			menu.addItem(restoreMenu);
			menu.addItem(quitMenu);
			
			return menu;
		}
		private function onSelectInit(e:Event):void
		{
			sendNotification(AppConstants.INIT_BOUNDS);
		}
		private function onSelectQuit(e:Event):void
		{
			closeView();
		}		
	}
}