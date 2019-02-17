package flixel.system.debug.ecs;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import flixel.system.FlxAssets;
import flixel.system.debug.Window;
import flixel.system.debug.DebuggerUtil;
import flixel.system.ui.FlxCheckBox;
import entithax.Systems;

private class SystemRow extends Sprite
{
	public var checkBox(default, null): FlxCheckBox;
	public var textField(default, null): TextField;

	public function new(name: String, parentWidth: Int, onClick: Bool->Void)
	{
		super();

		textField = DebuggerUtil.createTextField();

		checkBox = new FlxCheckBox(onClick);

		textField.selectable = false;
		textField.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEBUGGER, 12, 0xFFFFFF);
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.text = name;

		var textFieldMargin = ((Systems.LINE_HEIGHT - textField.height) * 0.5);
		var checkBoxMargin = ((Systems.LINE_HEIGHT - checkBox.height) * 0.5);
		
		textField.width = parentWidth - checkBox.width - (2 * checkBoxMargin);
		textField.y = textFieldMargin;

		addChild(textField);

		checkBox.x = parentWidth - checkBox.width - checkBoxMargin;
		checkBox.y = checkBoxMargin;

		addChild(checkBox);
	}
}

class Systems extends Window
{
	public static inline var LINE_HEIGHT: Int = 21;

	var rows: Array<SystemRow>;
	var container: Sprite;

    public function new(systems: entithax.Systems)
	{
		rows = new Array<SystemRow>();

		super("Systems", null, 200, 250, true, new Rectangle(0, 0, 200, 250), true);

		this.visible = true;

		container = new Sprite();
		container.x = 0;
		container.y = 15;

		addChild(container);
		
		for(s in systems.getExecuteSystems())
		{
			var completeSystemName: String = Type.getClassName(Type.getClass(s));
			var composedSystemName: Array<String> = completeSystemName.split(".");
			var systemName: String = composedSystemName[composedSystemName.length - 1];
			var index: Int = rows.length;

			addRow(index, new SystemRow(systemName, _width, function(checked: Bool) {
				systems.setExecuteSystemEnabled(index, checked);
			}));
		}
	}

	function addRow(index: Int, row: SystemRow): Void
	{
		row.y = LINE_HEIGHT * index;

		rows.push(row);
		container.addChild(row);

		minSize.x = Math.max(minSize.x, row.width);
		minSize.y = Math.max(minSize.y, container.y + container.height);
	}

	/**
	 * Adjusts the width and height of the text field accordingly.
	 */
	override function updateSize(): Void
	{
		super.updateSize();

		for(row in rows)
		{
			var margin = ((LINE_HEIGHT - row.checkBox.height) * 0.5);

			row.textField.width = _width - row.checkBox.width - (2 * margin);
			row.checkBox.x = _width - row.checkBox.width - margin;
		}
	}
}