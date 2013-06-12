package jp.tp.peggle2jump.controller.command.startup
{
	import jp.tp.peggle2jump.controller.constant.AppConstants;
	import jp.tp.peggle2jump.view.mediator.AppMediator;
	import jp.tp.peggle2jump.view.mediator.ConfigWindowMediator;
	import jp.tp.qlclock.model.proxy.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepareViewCommand extends SimpleCommand
	{
		override public function execute(n:INotification):void
		{
			var app:Peggle2JumpView = Peggle2JumpView(n.getBody());
			
			facade.registerMediator(new AppMediator(app));
			
			var cp:ConfigProxy = ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME));
			if(cp.bounds)
			{
//				sendNotification(AppConstants.PLAY_VIDEO);				
			}
			else
			{
				sendNotification(AppConstants.INIT_BOUNDS);
			}
		}
	}
}