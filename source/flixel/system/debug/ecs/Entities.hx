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
import entithax.Context;
import entithax.Entity;

class Entities extends Window
{
	private static inline var LINE_HEIGHT: Int = 21;

	var entitiesList: List<EntityRow>;

    public function new(context: Context)
	{
		entitiesList = new List<EntityRow>();

		var entities: Array<Entity> = context.getEntities();

		super("Entities", new GraphicCheckBoxCheckedButton(0, 0), 200, Window.HEADER_HEIGHT + (entities.length * LINE_HEIGHT), true);

		this.visible = true;

		entitiesList.x = 0;
		entitiesList.y = Window.HEADER_HEIGHT;

		addChild(entitiesList);

		for(e in entities)
		{
			var index: Int = entitiesList.rows.length;

			addRow(index, new EntityRow(e.name, _width, LINE_HEIGHT, function() {
				FlxG.game.debugger.addWindow(new flixel.system.debug.ecs.Components(e));
			}));
		}
	}

	function addRow(index: Int, row: EntityRow): Void
	{
		entitiesList.addRow(row);

		row.y = LINE_HEIGHT * index;

		minSize.x = Math.max(minSize.x, row.width);
		minSize.y = Math.max(minSize.y, entitiesList.y + entitiesList.height);
	}

	/**
	 * Adjusts the width and height of the text field accordingly.
	 */
	override function updateSize(): Void
	{
		super.updateSize();

		for(row in entitiesList.rows)
		{
			var margin = ((LINE_HEIGHT - row.button.height) * 0.5);

			row.textField.width = _width - row.button.width - (2 * margin);
			row.button.x = _width - row.button.width - margin;
		}
	}
}