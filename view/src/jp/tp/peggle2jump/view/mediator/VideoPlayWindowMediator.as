package jp.tp.peggle2jump.view.mediator
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jp.tp.peggle2jump.controller.constant.AppConstants;
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
			view.video.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onVideoTimeChange);
			view.video.addEventListener(TimeEvent.COMPLETE, onVideoComplete);
			view.video.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onVideoStageChange);
			view.video.addEventListener(MouseEvent.MOUSE_DOWN, onVideoMouseDown);
			view.addEventListener(Event.CLOSING, onWindowClosing);
			view.addEventListener(FlexNativeWindowEvent.DRAG_MOVE, onWindowMove);
			
			//set context menu
			view.container.contextMenu = initMenu();
			
			//appearance
			view.container.caption.visible = false;
			view.container.preview.visible = false;
			
			
			view.activate();
		}
		override public function onRemove():void
		{
			
		}
		override public function listNotificationInterests():Array
		{
			return [
				AppConstants.CLOSE_VIDEO
			];
		}
		override public function handleNotification(n:INotification):void
		{
			switch(n.getName())
			{
				case AppConstants.CLOSE_VIDEO:
					close();
					break;
			}
		}	
		private function get view():VideoWindow
		{
			return viewComponent as VideoWindow;
		}		
		private function onVideoMouseDown(e:MouseEvent):void
		{
			view.startDrag();
		}
		private function onVideoStageChange(e:MediaPlayerStateChangeEvent):void
		{
			if(e.state == MediaPlayerState.READY)
			{
				view.video.play();
			}
		}
		private function onVideoTimeChange(e:TimeEvent):void
		{
			if(e.time > 4.1)
			{
				view.container.clock.visible = true;
				view.video.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE, onVideoTimeChange);
				
			}
		}
		private function onVideoComplete(e:TimeEvent):void
		{
			close();
		}
		private function close():void
		{
			view.video.source = null;
			view.video.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE, onVideoTimeChange);
			view.video.removeEventListener(TimeEvent.COMPLETE, onVideoComplete);
			view.video.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onVideoStageChange);
			view.video.removeEventListener(MouseEvent.MOUSE_DOWN, onVideoMouseDown);
			view.close();
			onWindowClosing(null);
		}
		private function onWindowClosing(e:Event):void
		{
			view.removeEventListener(Event.CLOSING, onWindowClosing);
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
			close();
		}		
	}
}