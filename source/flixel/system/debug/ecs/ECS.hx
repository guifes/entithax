package flixel.system.debug.ecs;

import flixel.FlxG;
import entithax.Context;
import entithax.system.ISystems;

class ECS
{
    public static function start(context: Context, systems: ISystems): Void
    {
        FlxG.game.debugger.addWindow(new flixel.system.debug.ecs.Entities(context));
        FlxG.game.debugger.addWindow(new flixel.system.debug.ecs.Systems(systems));
    }
}