package entithax;

import entithax.Component;
import entithax.Entity;
import entithax.Group;
import entithax.Systems;
import entithax.detail.Macro;
import entithax.*;

import haxe.ds.GenericStack;
import haxe.ds.HashMap;

import de.polygonal.ds.tools.ObjectPool;
import de.polygonal.ds.HashTable;

import thx.Tuple;

#if macro
import haxe.macro.Expr;
#end

// typedef ComponentPool = GenericStack<Component>;
typedef ComponentPool = ObjectPool<Component>;

typedef ComponentPools = Array<ComponentPool>;

class Context
{
	public var globalEntity(default, null): Entity;

	private var creationIndex_: Int = 0;
	private var totalComponents_: Int;
	private var componentPools_ = new ComponentPools();
	private var entities_ = Entities.create();
	private var entitiesCache_: Array<Entity>;
	private var entitiesPool_: ObjectPool<Entity>;
	private var dbgUsePool_ = true;
	private var groups_: HashTable<Matcher, Group>;
	private var groupsForIndex_ = new Array<List<Group>>();
	private var debug_: Bool = false;

	public function new(debug: Bool = false)
	{
		this.debug_ = debug;

		totalComponents_ = Macro.getComponentCount();

		var hashCapacity: Int = nextPowerOf2(totalComponents_ * 2);

		if(this.debug_) trace("Group hash capacity " + hashCapacity);

		groups_ = new HashTable<Matcher, Group>(hashCapacity);

		if(this.debug_) trace("Allocating " + totalComponents_ + " positions to hold components in each entity");

		for (i in 0...totalComponents_) {
			groupsForIndex_[i] = new List<Group>();
		}

		entitiesPool_ = new ObjectPool(createEntityNew);

		globalEntity = createEntity("Global");
	}

	private static function nextPowerOf2(number: Int): Int
	{
		var count = 0;
        
        while(number > 0)
        {
            number >>= 1;
            count++;
        }
        
        return cast(Math.pow(2, count), Int);
	}

	public function createEntityNew(): Entity
	{
		var entity = new Entity();

		entity.initialize(creationIndex_++, totalComponents_, componentPools_);

		entity.onComponentAdded = updateGroupsComponentAddedOrRemoved;
		entity.onComponentRemoved = updateGroupsComponentAddedOrRemoved;
		entity.onComponentReplaced = updateGroupsComponentReplaced;

		return entity;
	}

	public function createEntity(name: String): Entity
	{
		// invalidate entitiesCache_
		entitiesCache_ = null;

		var entity: Entity;

		if (dbgUsePool_) {
			entity = entitiesPool_.get();
		} else {
			entity = createEntityNew();
		}

		entity.name = name;

		entity.reactivate(creationIndex_++);

		entities_.add(entity);

		return entity;
	}

	public function destroyEntity(entity: Entity)
	{
		var removed = entities_.remove(entity);

		if (!removed) {
			throw("Entity does not exist in this context.");
		}

		entitiesCache_ = null;

		entity.destroy();

		if (dbgUsePool_) {
			entitiesPool_.put(entity);
		}
	}

	public function createCollector(matcher: Matcher, eventMask: Int): Collector
	{
		var g = getGroup(matcher);
		return new Collector(g, eventMask);
	}

	// Returns a group for the specified matcher.
	public function getGroup(matcher: Matcher): Group
	{
		var groups: Array<Group> = [];
		var count = groups_.getAll(matcher, groups);
		var group: Group = null;

		if (count > 0)
		{
			if(count == 1)
			{
				group = groups[0];
			}
			else
			{
				for(g in groups)
				{
					if(g.matcher.equals(matcher))
					{
						group = g;
						break;
					}
				}
			}
		}

		if(group == null)
		{
			group = new Group(matcher);
			// 'Handle' all entities that are already in a context
			// Thus if the group is created later it will still be able to 'handle'
			// previously created entities
			for (e in getEntities()) {
				group.handleEntitySilently(e);
			}
			
			groups_.set(matcher, group);

			var allIndices = matcher.allIndices();

			for (i in allIndices) {
				groupsForIndex_[i].add(group);
			}
			// TODO call onGroupCreated
		}

		return group;
	}

	public function getEntities(): Array<Entity>
	{
		if (entitiesCache_ == null) {
			entitiesCache_ = entities_.toArray();
		}

		return entitiesCache_;
	}

	public function updateGroupsComponentAddedOrRemoved(entity: Entity, index: Int, component: Component)
	{
		var groups = groupsForIndex_[index];
		var callbacks = new List<Tuple2<Group, DelegateGroupChanged>>();

		for (g in groups)
		{
			var cb = g.handleEntity(entity);
			
			if (cb != null)
				callbacks.add(new Tuple2(g, cb));
		}

		for (cbt in callbacks)
		{
			cbt._1.invoke(cbt._0, entity, index, component);
		}
	}

	public function updateGroupsComponentReplaced(entity: Entity, index: Int, previousComponent: Component, newComponent: Component)
	{
		var groups = groupsForIndex_[index];

		for (g in groups)
		{
			if(g.matcher.matches(entity))
			{
				g.updateEntity(entity, index, previousComponent, newComponent);
			}
			// else
			// {
			// 	trace("Updated component " + index + "not matched by " + g.matcher.indicesAllOf);
			// }
		}
	}

	macro public function add(self:Expr, object:ExprOf<Component>): Expr
	{
		var componentId = macro entithax.detail.Macro.getComponentId($object);
		return macro $self.globalEntity.addComponent($componentId, $object);
	}

	macro public function get<A:Component> (self: Expr, componentClass: ExprOf<Class<A>>): ExprOf<A>
	{
		var componentId = macro $componentClass.id_;
		return macro cast $self.globalEntity.getComponent($componentClass.id_);
	}

	macro public function remove<A:Component> (self: Expr, componentClass: ExprOf<Class<A>>): ExprOf<A>
	{
		var componentId = macro $componentClass.id_;
		return macro cast $self.globalEntity.replaceComponent($componentClass.id_, null);
	}

	macro public function replace(self: Expr, object: ExprOf<Component>): Expr
	{
		var componentId = macro entithax.detail.Macro.getComponentId($object);
		return macro $self.globalEntity.replaceComponent($componentId, $object);
	}
}