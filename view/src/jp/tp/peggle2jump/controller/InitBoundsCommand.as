package jp.tp.peggle2jump.controller
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.geom.Rectangle;
	
	import jp.tp.peggle2jump.controller.constant.AppConstants;
	import jp.tp.peggle2jump.model.proxy.ConfigProxy;
	import jp.tp.peggle2jump.view.component.VideoWindow;
	import jp.tp.peggle2jump.view.mediator.VideoConfWindowMediator;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitBoundsCommand extends SimpleCommand
	{
		public function InitBoundsCommand()
		{
			super();
		}
		override public function execute(n:INotification):void
		{
			var med:IMediator = facade.retrieveMediator(VideoConfWindowMediator.NAME);
			if(med) return;
			
			//再生中のプレイヤーを閉じる
			sendNotification(AppConstants.CLOSE_VIDEO);

			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions;
			initOptions.type = NativeWindowType.UTILITY;
			var win:VideoWindow = new VideoWindow(initOptions);
			win.title = "window setting";
			
			var chromeHeight:Number = win.height - win.stage.stageHeight;
			var cp:ConfigProxy = ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME));
			var b:Rectangle = cp.bounds || cp.defaultBounds;
			win.bounds = new Rectangle(b.x, b.y - chromeHeight, b.width, b.height + chromeHeight);
			
			
			facade.registerMediator(new VideoConfWindowMediator(win));
		}
	}
}