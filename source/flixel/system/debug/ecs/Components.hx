package flixel.system.debug.ecs;

import flash.display.Sprite;
import flash.geom.Rectangle;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.events.MouseEvent;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.system.debug.Window;
import flixel.system.debug.DebuggerUtil;
import flixel.system.ui.FlxCheckBox.GraphicCheckBoxCheckedButton;
import entithax.Entity;
import entithax.Component;

class Components extends Window
{
	private static inline var LINE_HEIGHT: Int = 21;

	var componentsList: List<ComponentRow>;

    public function new(entity: Entity)
	{
		componentsList = new List<ComponentRow>();

		var components: Array<Component> = entity.getAllComponents();

		super(entity.name, new GraphicCheckBoxCheckedButton(0, 0), 200, Window.HEADER_HEIGHT + (components.length * LINE_HEIGHT), true);

		this.visible = true;

		componentsList.x = 0;
		componentsList.y = Window.HEADER_HEIGHT;

		addChild(componentsList);

		for(c in components)
		{
			var index: Int = componentsList.rows.length;

			var completeComponentName: String = Type.getClassName(Type.getClass(c));
			var composedComponentName: Array<String> = completeComponentName.split(".");
			var componentName: String = composedComponentName[composedComponentName.length - 1];
			
			addRow(index, new ComponentRow(componentName, _width, LINE_HEIGHT));
		}
	}

	function addRow(index: Int, row: ComponentRow): Void
	{
		componentsList.addRow(row);

		row.y = LINE_HEIGHT * index;

		minSize.x = Math.max(minSize.x, row.width);
		minSize.y = Math.max(minSize.y, componentsList.y + componentsList.height);
	}

	/**
	 * Adjusts the width and height of the text field accordingly.
	 */
	override function updateSize(): Void
	{
		super.updateSize();

		for(row in componentsList.rows)
		{
			var margin = ((LINE_HEIGHT - row.textField.height) * 0.5);

			row.textField.width = _width - margin;
		}
	}
}