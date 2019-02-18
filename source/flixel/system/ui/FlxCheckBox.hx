package flixel.system.ui;

import flash.display.BitmapData;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.Window;

@:bitmap("assets/images/debugger/buttons/checkboxChecked.png")
@:noCompletion class GraphicCheckBoxCheckedButton extends BitmapData {}

@:bitmap("assets/images/debugger/buttons/checkboxUnchecked.png")
@:noCompletion class GraphicCheckBoxUncheckedButton extends BitmapData {}

class FlxCheckBox extends FlxSystemButton
{
    public function new(onClick: Bool->Void)
    {
        super(new GraphicCheckBoxCheckedButton(0, 0), function() {
            onClick(this.toggled);
        }, true);
        this.alpha = Window.HEADER_ALPHA;
        this.toggled = true;
    }

    override function set_toggled(Value: Bool): Bool
	{
        this.changeIcon(Value ? new GraphicCheckBoxCheckedButton(0, 0) : new GraphicCheckBoxUncheckedButton(0, 0));
		return toggled = Value;
	}
}