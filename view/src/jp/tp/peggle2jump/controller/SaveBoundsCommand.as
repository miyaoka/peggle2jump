package jp.tp.peggle2jump.controller
{
	import flash.geom.Rectangle;
	
	import jp.tp.peggle2jump.model.proxy.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SaveBoundsCommand extends SimpleCommand
	{
		public function SaveBoundsCommand()
		{
			super();
		}
		override public function execute(n:INotification):void
		{
			var proxy:ConfigProxy = ConfigProxy(facade.retrieveProxy(ConfigProxy.NAME));
			var b:Rectangle = Rectangle(n.getBody());
			
			//16:9
			if(b.width /16 > b.height /9)
			{
				var w:Number = b.height / 9 * 16;
				b.x += (b.width - w) / 2;
				b.width = w;
			}
			else
			{
				var h:Number = b.width / 16 * 9;
				b.y += (b.height - h) / 2;
				b.height = h;
			}
			
			proxy.bounds = b;
		}
	}
}