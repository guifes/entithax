package flixel.system.debug.ecs;

import flash.display.Sprite;
import flash.geom.Rectangle;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import flixel.system.FlxAssets;
import flixel.system.debug.Window;
import flixel.system.debug.DebuggerUtil;
import flixel.system.ui.FlxCheckBox;
import entithax.Systems;

class Systems extends Window
{
	private static inline var LINE_HEIGHT:Int = 15;
	private static inline var GUTTER = 15;

	var container: Sprite;
	var rowCount: Int;

    public function new(systems: entithax.Systems)
	{
		super("Systems", null, 200, 300, true, new Rectangle(0, 0, 200, 300), true);

		this.rowCount = 0;
		this.visible = true;

		container = new Sprite();
		container.x = 0;
		container.y = GUTTER;

		addChild(container);

		for(s in systems.getSystems())
		{
            var completeSystemName: String = Type.getClassName(Type.getClass(s));
			var composedSystemName: Array<String> = completeSystemName.split(".");
			var systemName: String = composedSystemName[composedSystemName.length - 1];

			addRow(systemName);
		}
	}

	private function addRow(text: String): Void
	{
		var textField = DebuggerUtil.createTextField();

		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
		textField.autoSize = TextFieldAutoSize.NONE;
		textField.height = LINE_HEIGHT;
		textField.text = text;
		textField.width = textField.textWidth;
		textField.y = LINE_HEIGHT * rowCount;

		container.addChild(textField);

        var checkBox = new FlxCheckBox();

		container.addChild(checkBox);

		rowCount++;
	}
}