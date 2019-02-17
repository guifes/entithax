package entithax;

import entithax.Context;
import entithax.Entity;
import entithax.Collector;
import haxe.ds.Vector;

interface ISystem {}

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

typedef ExecuteSystemInfo = { system: IExecuteSystem, enabled: Bool };

class Systems implements IInitializeSystem implements IExecuteSystem
{
	private var initializeSystems: Vector<IInitializeSystem>;
	private var initializeSystemsCount: Int;
	private var executeSystemsCount: Int;
	private var executeSystems: Vector<IExecuteSystem>;
	private var executeSystemsInfo: Vector<ExecuteSystemInfo>;
	private var size: Int;

	public function new(size: Int)
	{
		this.size = size;

		initializeSystemsCount = 0;
		executeSystemsCount = 0;

		initializeSystems = new Vector<IInitializeSystem>(size);
		executeSystems = new Vector<IExecuteSystem>(size);
		executeSystemsInfo = new Vector<ExecuteSystemInfo>(size);
	}

	public function execute(elapsed: Float)
	{
		for (i in 0...executeSystemsCount)
		{
			var s = executeSystemsInfo[i];

			if(s.enabled)
			{
				s.system.execute(elapsed);
			}
		}
	}

	public function initialize() 
	{
		for (i in 0...initializeSystemsCount)
		{
			var s = initializeSystems[i];
			s.initialize();
		}
	}

	public function getExecuteSystems(): Array<IExecuteSystem>
	{
		return executeSystems.toArray().slice(0, executeSystemsCount);
	}

	public function setExecuteSystemEnabled(index: Int, enable: Bool)
	{
		executeSystemsInfo[index].enabled = enable;
	}

	public function add(system: ISystem)
	{
		if (Std.is(system, IExecuteSystem))
		{
			var bla: IExecuteSystem = cast system;

			executeSystems[executeSystemsCount] = bla;
			executeSystemsInfo[executeSystemsCount++] = { system: bla, enabled: true };
		}
			
		if (Std.is(system, IInitializeSystem))
		{
			initializeSystems[initializeSystemsCount++] = cast system;
		}

		return this;
	}
}