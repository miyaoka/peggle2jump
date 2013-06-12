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
	
	public class ResetBoundsCommand extends SimpleCommand
	{
		public function ResetBoundsCommand()
		{
			super();
		}
		override public function execute(n:INotification):void
		{
			var cp:ConfigProxy = ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME));
			cp.resetBounds();
			sendNotification(AppConstants.INIT_BOUNDS);
		}
	}
}