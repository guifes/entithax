package flixel.system.debug.ecs;

import flash.display.Sprite;
import flash.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import flixel.system.FlxAssets;
import flixel.system.debug.DebuggerUtil;

class ComponentRow extends Sprite
{
	public var textField(default, null): TextField;

	public function new(name: String, w: Int, h: Int)
	{
		super();

		textField = DebuggerUtil.createTextField();

		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.text = name;

		var textFieldMargin = ((h - textField.height) * 0.5);
		
		textField.width = w - textFieldMargin;
		textField.y = textFieldMargin;

		addChild(textField);
	}
}