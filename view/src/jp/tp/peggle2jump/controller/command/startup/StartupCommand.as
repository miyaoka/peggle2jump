package jp.tp.peggle2jump.controller.command.startup
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	import jp.tp.peggle2jump.controller.command.startup.PrepareModelCommand;
	
	public class StartupCommand extends MacroCommand
	{
		public function StartupCommand()
		{
			super();
		}
		override protected function initializeMacroCommand():void
		{
			addSubCommand(PrepareContorollerCommand);
			addSubCommand(PrepareModelCommand);
			addSubCommand(PrepareViewCommand);
		}
	}
}