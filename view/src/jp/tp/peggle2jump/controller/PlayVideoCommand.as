package jp.tp.peggle2jump.controller
{
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.geom.Rectangle;
	
	import jp.tp.peggle2jump.view.component.VideoWindow;
	import jp.tp.peggle2jump.view.mediator.VideoPlayWindowMediator;
	import jp.tp.peggle2jump.model.proxy.ConfigProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class PlayVideoCommand extends SimpleCommand
	{
		public function PlayVideoCommand()
		{
		}
		override public function execute(n:INotification):void
		{
			var med:IMediator = facade.retrieveMediator(VideoPlayWindowMediator.NAME);
			if(med) return;
			
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions;
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.transparent = true;
			initOptions.type = NativeWindowType.LIGHTWEIGHT;
			
			var win:VideoWindow = new VideoWindow(initOptions);
			var cp:ConfigProxy = ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME));
			var b:Rectangle = cp.bounds;
			
			//bounds未定義時は起動しない
			//（初回設定中に時報で起動するケース）
			if(!b) return;

			win.bounds = cp.bounds;
			
			facade.registerMediator(new VideoPlayWindowMediator(win));
		}		
	}
}