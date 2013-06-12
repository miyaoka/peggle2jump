package jp.tp.peggle2jump.view.mediator
{
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import jp.tp.peggle2jump.controller.constant.AppConstants;
	import jp.tp.peggle2jump.model.proxy.ClockTimeProxy;
	import jp.tp.peggle2jump.model.proxy.ConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AppMediator extends Mediator
	{
		public static const NAME:String = "AppMediator";
		
		public function AppMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void
		{
			view.nativeApplication.addEventListener(Event.EXITING, onExiting);
			initIcon();
		}
		override public function onRemove():void
		{
			
		}
		override public function listNotificationInterests():Array
		{
			return [
				ClockTimeProxy.TIME_UPDATED
				];
		}
		override public function handleNotification(n:INotification):void
		{
			switch(n.getName())
			{
				case ClockTimeProxy.TIME_UPDATED:
					onTimeUpdate();
					break;
			}
			
		}
		private function get view():Peggle2JumpView
		{
			return viewComponent as Peggle2JumpView;
		}
		private function onTimeUpdate():void
		{
			sendNotification(AppConstants.PLAY_VIDEO);
		}
		private function onExiting(e:Event):void
		{
		}
		/**
		 * タスクトレイ/Dockの設定
		 */ 
		private function initIcon():void
		{
			//MacDock
			if(NativeApplication.supportsDockIcon)
			{
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				dockIcon.menu = createIconMenu();
			}
			//WinSystemTray
			else if (NativeApplication.supportsSystemTrayIcon)
			{
				var sysTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = "Peggle2Jump";
				sysTrayIcon.menu = createIconMenu();
			}
			loadIcons();
			//MacAppMenu
			if (NativeApplication.supportsMenu) { 
//				view.nativeApplication.menu = createIconMenu();
			} 			
			
		}
		/**
		 * タスクトレイ/Dockのメニュー作成
		 */ 
		private function createIconMenu():NativeMenu
		{
			jumpMenu.addEventListener(Event.SELECT, onSelectJump);
			initMenu.addEventListener(Event.SELECT, onSelectInit);
			resetMenu.addEventListener(Event.SELECT, onSelectReset);
			quitMenu.addEventListener(Event.SELECT, onSelectQuit);
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			
			versionMenu.label = appXml.ns::name + " v" + appXml.ns::versionNumber; 
			
			var iconMenu:NativeMenu = new NativeMenu();
			iconMenu.addItem(jumpMenu);
			iconMenu.addItem(initMenu);
			iconMenu.addItem(resetMenu);
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			iconMenu.addItem(versionMenu);
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			iconMenu.addItem(quitMenu);
			
			return iconMenu;
		}
		private function loadIcons():void
		{
			var bmds:Array = [];
			var sizes:Array = [16, 32, 48, 128];
			loadIcon(sizes, bmds);
		}
		private function loadIcon(sizes:Array, bmds:Array):void
		{
			if(sizes.length == 0)
			{
				NativeApplication.nativeApplication.icon.bitmaps = bmds;
				return;
			}
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var li:LoaderInfo = LoaderInfo(e.target);
				li.removeEventListener(Event.COMPLETE, arguments.callee);
				bmds.push(Bitmap(li.content).bitmapData);
				loadIcon(sizes, bmds);
			});
			loader.load(new URLRequest("assets/icons/icon" + sizes.shift() + ".png"));
		}
	
		private var quitMenu:NativeMenuItem = new NativeMenuItem("Quit");
		private var jumpMenu:NativeMenuItem = new NativeMenuItem("Jump now!!");
		private var initMenu:NativeMenuItem = new NativeMenuItem("Set size and position");
		private var resetMenu:NativeMenuItem = new NativeMenuItem("Reset position");
		private var versionMenu:NativeMenuItem = new NativeMenuItem();
		private function onSelectJump(e:Event):void
		{
			sendNotification(AppConstants.PLAY_VIDEO);
		}
		private function onSelectInit(e:Event):void
		{
			sendNotification(AppConstants.INIT_BOUNDS);
		}
		private function onSelectQuit(e:Event):void
		{
			view.nativeApplication.exit();
		}
		private function onSelectReset(e:Event):void
		{
			sendNotification(AppConstants.RESET_BOUNDS);
		}
	}
}