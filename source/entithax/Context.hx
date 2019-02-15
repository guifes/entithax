package entithax;

import entithax.Component;
import entithax.Entity;
import entithax.Group;
import entithax.Systems;
import entithax.*;

import haxe.ds.GenericStack;
import haxe.ds.HashMap;

import de.polygonal.ds.tools.ObjectPool;

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
	private var groups_ = new HashMap<Matcher, Group>();
	private var groupsForIndex_ = new Array<List<Group>>();
	private var sharedSystems_ = new Map<String, ISystem>(); // Replace by macro ClassName > Index implementation

	public function new(totalComponents: Int, startCreationIndex: Int)
	{
		totalComponents_ = totalComponents;
		creationIndex_ = startCreationIndex;

		for (i in 0...totalComponents) {
			groupsForIndex_[i] = new List<Group>();
		}

		entitiesPool_ = new ObjectPool(createEntityNew);

		globalEntity = createEntity("Global");
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

	public function createCollector(matcher: Matcher, event: GroupEvent): Collector
	{
		var g = getGroup(matcher);
		return new Collector(g, event);
	}

	// Returns a group for the specified matcher.
	public function getGroup(matcher: Matcher): Group
	{
		var group = groups_.get(matcher);

		if (group == null) {
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
		// trace("NotImplemented");
		var groups = groupsForIndex_[index];

		for (g in groups)
		{
			g.updateEntity(entity, index, previousComponent, newComponent);
		}
	}

	public macro function add(self:Expr, object:ExprOf<Component>): Expr
	{
		var componentId = macro entithax.detail.Macro.getComponentId($object);
		return macro $self.globalEntity.addComponent($componentId, $object);
    }

	macro public function get<A:Component> (self: Expr, componentClass: ExprOf<Class<A>>): ExprOf<A>
    {
		var componentId = macro $componentClass.id_;
		return macro cast $self.globalEntity.getComponent($componentClass.id_);
    }

	public function addSharedSystem(key: String, system: ISystem)
	{
		sharedSystems_.set(key, system);
	}

	public function getSharedSystem(key: String): ISystem
	{
		return sharedSystems_.get(key);
	}
}