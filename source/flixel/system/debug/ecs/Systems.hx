package flixel.system.debug.ecs;

import flash.display.Sprite;
import flixel.system.FlxAssets;
import flixel.system.debug.Window;
import flixel.system.ui.FlxCheckBox.GraphicCheckBoxCheckedButton;
import entithax.Systems;

class Systems extends Window
{
	public static inline var LINE_HEIGHT: Int = 21;
	
	var systemList: List<SystemRow>;

    public function new(systems: entithax.Systems)
	{
		var systemsArray: Array<IExecuteSystem> = systems.getExecuteSystems();

		systemList = new List<SystemRow>();

		super("Systems", new GraphicCheckBoxCheckedButton(0, 0), 200, Window.HEADER_HEIGHT + (systemsArray.length * LINE_HEIGHT), true);

		this.visible = true;

		systemList.x = 0;
		systemList.y = Window.HEADER_HEIGHT;

		addChild(systemList);
		
		for(s in systemsArray)
		{
			var completeSystemName: String = Type.getClassName(Type.getClass(s));
			var composedSystemName: Array<String> = completeSystemName.split(".");
			var systemName: String = composedSystemName[composedSystemName.length - 1];
			var index: Int = systemList.rows.length;

			addRow(index, new SystemRow(systemName, _width, LINE_HEIGHT, function(checked: Bool) {
				systems.setExecuteSystemEnabled(index, checked);
			}));
		}
	}

	function addRow(index: Int, row: SystemRow): Void
	{
		systemList.addRow(row);

		row.y = LINE_HEIGHT * index;

		minSize.x = Math.max(minSize.x, row.width);
		minSize.y = Math.max(minSize.y, systemList.y + systemList.height);
	}

	/**
	 * Adjusts the width and height of the text field accordingly.
	 */
	override function updateSize(): Void
	{
		super.updateSize();

		for(row in systemList.rows)
		{
			var margin = ((LINE_HEIGHT - row.checkBox.height) * 0.5);

			row.textField.width = _width - row.checkBox.width - (2 * margin);
			row.checkBox.x = _width - row.checkBox.width - margin;
		}
	}
}