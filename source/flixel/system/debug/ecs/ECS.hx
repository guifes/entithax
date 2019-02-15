package flixel.system.debug.ecs;

import flixel.FlxG;
import entithax.Context;
import entithax.Systems;

class ECS
{
    public static function start(context: Context, systems: Systems): Void
    {
        FlxG.game.debugger.addWindow(new flixel.system.debug.ecs.Entities(context));
        FlxG.game.debugger.addWindow(new flixel.system.debug.ecs.Systems(systems));
    }
}