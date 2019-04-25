package entithax;

import entithax.Component;
import entithax.Entity;
import entithax.Matcher;
import entithax.DelegateGroupChanged;

@:enum abstract GroupEvent(Int) from Int to Int
{
	var Added = 1;
	var Removed = 2;
	var Updated = 4;
}

typedef GroupChanged = Group -> Entity -> Int -> Component -> Void;

// typedef GroupReplaced = Entity -> Int -> Component -> Component -> Void;

class Group
{
	public var onEntityAdded = new DelegateGroupChanged();
	public var onEntityRemoved = new DelegateGroupChanged();
	public var onEntityUpdated = new DelegateGroupChanged();

	public var matcher(default, null): Matcher;

	private var entities_ =  Entities.create();
	private var entitiesCache_: Array<Entity>;
	private var entityCache_ : Entity;

	private inline function invalidateCaches()
	{
		entitiesCache_ = null;
		entityCache_ = null;
	}

	public function new(_matcher: Matcher)
	{
		matcher = _matcher;
	}

	public function handleEntitySilently(entity: Entity)
	{
		if (matcher.matches(entity))
			addEntitySilently(entity);
		else
			removeEntitySilently(entity);
	}

	public function handleEntity(entity: Entity)
	{
		// if we are removing component from entity 
		// then it (component) is already set to null
		// thus matcher will fail
		if (matcher.matches(entity))
			return addEntity(entity);
		else
			return removeEntity(entity);
	}

	private function addEntitySilently(entity: Entity)
	{
		if (entities_.add(entity)) {
			invalidateCaches();
			return true;
		}

		return false;
	}

	public function addEntity(entity: Entity)
	{
		if (addEntitySilently(entity))
			return onEntityAdded;
		
		return null;
	}

	public function removeEntity(entity: Entity)
	{
		if (removeEntitySilently(entity))
			return onEntityRemoved;
		
		return null;
	}

	private function removeEntitySilently(entity: Entity)
	{
		if (entities_.remove(entity))
		{
			invalidateCaches();
			return true;
		}

		return false;
	}

	public function getEntities()
	{
		if (entitiesCache_ == null) {
			entitiesCache_ = entities_.toArray();
		}

		return entitiesCache_;
	}

	public function getSingleEntity()
	{
		if (entityCache_ == null)
		{
			var c = entities_.length;

			if (c == 1) {
				entityCache_ = entities_.iterator().next();
			}
			else if (c > 1) {
				trace(entities_);
				throw("Group has more than one entity!");
			}
		}

		return entityCache_;
	}

	// This handles entity replace/update
	public function updateEntity(entity: Entity, index: Int, previousComponent: Component, newComponent: Component)
	{
		if (onEntityUpdated != null)
			onEntityUpdated.invoke(this, entity, index, newComponent);
	}
}