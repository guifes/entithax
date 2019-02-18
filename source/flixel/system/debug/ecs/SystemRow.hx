package flixel.system.debug.ecs;

import flash.display.Sprite;
import flash.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import flixel.system.FlxAssets;
import flixel.system.debug.DebuggerUtil;
import flixel.system.ui.FlxCheckBox;

class SystemRow extends Sprite
{
	public var checkBox(default, null): FlxCheckBox;
	public var textField(default, null): TextField;

	public function new(name: String, w: Int, h: Int, onClick: Bool->Void)
	{
		super();

		textField = DebuggerUtil.createTextField();

		checkBox = new FlxCheckBox(onClick);

		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.text = name;

		var textFieldMargin = ((h - textField.height) * 0.5);
		var checkBoxMargin = ((h - checkBox.height) * 0.5);
		
		textField.width = w - checkBox.width - (2 * checkBoxMargin);
		textField.y = textFieldMargin;

		addChild(textField);

		checkBox.x = w - checkBox.width - checkBoxMargin;
		checkBox.y = checkBoxMargin;

		addChild(checkBox);
	}
}