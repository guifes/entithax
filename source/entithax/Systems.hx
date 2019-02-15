package entithax;

import entithax.Context;
import entithax.Entity;
import entithax.Collector;

interface ISystem
{

}

/// Implement this interface if you want to create a system which should be
/// initialized once in the beginning.
interface IInitializeSystem extends ISystem
{
	public function initialize(): Void;
}

/// Implement this interface if you want to create a system which should be
/// executed every frame.
interface IExecuteSystem extends ISystem
{
	public function execute(elapsed:Float): Void;
}

class Systems implements IInitializeSystem implements IExecuteSystem
{
	private var initializeSystems = new List<IInitializeSystem>();
	private var executeSystems = new List<IExecuteSystem>();

	public function new()
	{

	}

	public function execute(elapsed:Float)
	{
		for (s in executeSystems)
		{
			s.execute(elapsed);
		}
	}

	public function initialize() 
	{
		for (s in initializeSystems)
		{
			s.initialize();
		}
	}

	public function getSystems(): List<IExecuteSystem>
	{
		return executeSystems;
	}

	public function add(system: ISystem)
	{
		if (Std.is(system, IExecuteSystem))
		{
			executeSystems.add(cast system);
		}
			
		if (Std.is(system, IInitializeSystem))
		{
			initializeSystems.add(cast system);
		}

		return this;
	}
}