package jp.tp.peggle2jump.view.mediator
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jp.tp.peggle2jump.controller.constant.AppConstants;
	import jp.tp.peggle2jump.view.component.VideoContainer;
	import jp.tp.peggle2jump.view.component.VideoWindow;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.VideoDisplay;
	
	public class VideoConfWindowMediator extends Mediator
	{
		public static const NAME:String = "VideoConfWindowMediator";
		
		public function VideoConfWindowMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			view.addEventListener(Event.CLOSING, onWindowClosing);
			view.container.preview.addEventListener(FlexEvent.BUTTON_DOWN, onPreviewButtonDown);
			view.video.addEventListener(MouseEvent.MOUSE_DOWN, onVideoMouseDown);
			
			view.activate();
		}
		override public function onRemove():void
		{
			
		}
		override public function listNotificationInterests():Array
		{
			return [
			];
		}
		override public function handleNotification(n:INotification):void
		{
			switch(n.getName())
			{
			}
		}	
		private function get view():VideoWindow
		{
			return viewComponent as VideoWindow;
		}		
		private function onWindowClosing(e:Event):void
		{
			view.video.source = null;
			view.removeEventListener(Event.CLOSING, onWindowClosing);
			view.container.preview.removeEventListener(FlexEvent.BUTTON_DOWN, onPreviewButtonDown);
			view.video.removeEventListener(MouseEvent.MOUSE_DOWN, onVideoMouseDown);
			
			saveBounds();
			facade.removeMediator(NAME);
		}
		private function onPreviewButtonDown(e:FlexEvent):void
		{
			view.close();
			onWindowClosing(null);
			sendNotification(AppConstants.PLAY_VIDEO);
		}
		private function saveBounds():void
		{
			var v:VideoDisplay = view.video;
			var pt:Point = view.globalToScreen(new Point(v.x, v.y));
			sendNotification(AppConstants.SAVE_BOUNDS, new Rectangle(pt.x, pt.y, v.width, v.height));
		}
		private function onVideoMouseDown(e:MouseEvent):void
		{
			view.startDrag();
		}
	}
}