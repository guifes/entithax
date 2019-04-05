package entithax;

import entithax.Matcher;
import entithax.Group;
import entithax.Context;

class ContextExtension
{
    static public function getMatchedEntities(context: Context, matcher: Matcher): Array<Entity>
	{
        return context.getGroup(matcher).getEntities();
	}

    static public function getMatchedEntity(context: Context, matcher: Matcher): Entity
	{
        return context.getGroup(matcher).getEntities()[0];
	}
}