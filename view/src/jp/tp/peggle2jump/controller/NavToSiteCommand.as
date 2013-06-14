package jp.tp.peggle2jump.controller
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NavToSiteCommand extends SimpleCommand
	{
		private var req:URLRequest;
		public function NavToSiteCommand()
		{
			super();
			req = new URLRequest("http://sourceforge.net/projects/peggle2jump/");
		}
		override public function execute(n:INotification):void
		{
			navigateToURL(req);
		}
	}
}