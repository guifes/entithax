package flixel.system.debug.ecs;

import flash.display.Sprite;
import flash.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import flixel.system.FlxAssets;
import flixel.system.debug.DebuggerUtil;
import flixel.system.ui.FlxSystemButton;
import flixel.system.ui.FlxCheckBox.GraphicCheckBoxUncheckedButton;

class EntityRow extends Sprite
{
	public var button(default, null): FlxSystemButton;
	public var textField(default, null): TextField;

	public function new(name: String, w: Int, h: Int, onClick: Void->Void)
	{
		super();

		textField = DebuggerUtil.createTextField();

		button = new FlxSystemButton(new GraphicCheckBoxUncheckedButton(0, 0), onClick);

		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.text = name;

		var textFieldMargin = ((h - textField.height) * 0.5);
		var buttonMargin = ((h - button.height) * 0.5);
		
		textField.width = w - button.width - (2 * buttonMargin);
		textField.y = textFieldMargin;

		addChild(textField);

		button.x = w - button.width - buttonMargin;
		button.y = buttonMargin;

		addChild(button);
	}
}