package jp.tp.peggle2jump.view.component
{
	import flash.display.NativeWindowInitOptions;
	
	import spark.components.VideoDisplay;
	
	public class VideoWindow extends FlexNativeWindow
	{
		public var container:VideoContainer;
		public var video:VideoDisplay;
		public function VideoWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
			
			//UIComponent追加
			container = new VideoContainer;
			addChildControls(container);
			
			//videodisplay参照
			video = container.video;
		}
	}
}