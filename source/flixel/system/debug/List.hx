package flixel.system.debug;

import flash.display.Sprite;

class List<T:Sprite> extends Sprite
{
	public static inline var LINE_HEIGHT: Int = 21;

	public var rows(default, null): Array<T>;

    public function new()
	{
		super();

		rows = new Array<T>();
	}

	public function addRow(row: T): Void
	{
        var index: Int = rows.length;

		row.y = LINE_HEIGHT * index;

		rows.push(row);
		addChild(row);
	}
}