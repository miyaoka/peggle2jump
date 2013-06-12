package jp.tp.peggle2jump.controller.command.startup
{
	import jp.tp.peggle2jump.controller.PlayVideoCommand;
	import jp.tp.peggle2jump.controller.InitBoundsCommand;
	import jp.tp.peggle2jump.controller.SaveBoundsCommand;
	import jp.tp.peggle2jump.controller.constant.AppConstants;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepareContorollerCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(AppConstants.SAVE_BOUNDS, SaveBoundsCommand);
			facade.registerCommand(AppConstants.PLAY_VIDEO, PlayVideoCommand);
			facade.registerCommand(AppConstants.INIT_BOUNDS, InitBoundsCommand);
		}
	}
}