package flixel.system.ui;

import flash.display.BitmapData;
import flixel.system.ui.FlxSystemButton;
import flixel.system.debug.Window;

@:bitmap("assets/images/debugger/buttons/checkboxChecked.png")
private class GraphicCheckBoxCheckedButton extends BitmapData {}

@:bitmap("assets/images/debugger/buttons/checkboxUnchecked.png")
private class GraphicCheckBoxUncheckedButton extends BitmapData {}

class FlxCheckBox extends FlxSystemButton
{
    public function new()
    {
        super(new GraphicCheckBoxUncheckedButton(0, 0), onClick);
        this.alpha = Window.HEADER_ALPHA;
    }

    private function onClick()
    {
        trace("PQP!");
    }
}