package jp.tp.peggle2jump
{
	import jp.tp.peggle2jump.controller.command.startup.StartupCommand;
	import jp.tp.peggle2jump.controller.constant.AppConstants;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static function getInstance():ApplicationFacade
		{
			if(!instance) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		public function startup(app:Peggle2JumpView):void
		{
			registerCommand(AppConstants.STARTUP, StartupCommand);
			sendNotification(AppConstants.STARTUP, app);
		}
	}
}