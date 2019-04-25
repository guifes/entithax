package entithax;

import entithax.Entity;
import entithax.Group;
import entithax.Component;

/// A Collector can observe one or more groups from the same context
/// and collects changed entities based on the specified groupEvent.
class Collector
{
	public var collectedEntities(default, null) = Entities.create();

	private var group_ : Group;
	private var groupEventMask_: Int;
	private var active_: Bool;
	
	public function new(group: Group, groupEventMask: Int)
	{
		group_ = group;
		groupEventMask_ = groupEventMask;
		active_ = true;

		initialize();
	}

	// Add entity to collector
	public function collectEntity(group: Group, entity: Entity, index: Int, component: Component)
	{
		if(active_)
			collectedEntities.add(entity);
	}

    /// Initializes the Collector and will start collecting
    /// changed entities. Collectors are activated by default.
	public function initialize()
	{
		if(groupEventMask_ & GroupEvent.Added > 0)
			group_.onEntityAdded.addDelegate(0, collectEntity);
		
		if(groupEventMask_ & GroupEvent.Removed > 0)
			group_.onEntityRemoved.addDelegate(0, collectEntity);

		if(groupEventMask_ & GroupEvent.Updated > 0)
			group_.onEntityUpdated.addDelegate(0, collectEntity);
	}

	public function activate()
	{
		active_ = true;
	}

	public function deactivate()
	{
		active_ = false;
	}

	public function clearCollected()
	{
		collectedEntities = collectedEntities.empty();
	}
}