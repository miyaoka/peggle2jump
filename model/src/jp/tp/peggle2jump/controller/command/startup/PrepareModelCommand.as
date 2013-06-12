package jp.tp.peggle2jump.controller.command.startup
{
	import jp.tp.peggle2jump.model.proxy.ClockTimeProxy;
	import jp.tp.peggle2jump.model.proxy.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepareModelCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var clock:ClockTimeProxy = new ClockTimeProxy();
			var conf:ConfigProxy = new ConfigProxy();
			facade.registerProxy(clock);
			facade.registerProxy(conf);
		}
	}
}