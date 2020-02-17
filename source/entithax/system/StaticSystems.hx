package entithax.system;

import haxe.ds.Vector;

class StaticSystems implements ISystems
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
		for(i in 0...executeSystemsCount)
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
		for(i in 0...initializeSystemsCount)
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
		if(Std.is(system, IExecuteSystem))
		{
			var eSystem: IExecuteSystem = cast system;

			executeSystems[executeSystemsCount] = eSystem;
			executeSystemsInfo[executeSystemsCount++] = {system: eSystem, enabled: true};
		}

		if(Std.is(system, IInitializeSystem))
		{
			initializeSystems[initializeSystemsCount++] = cast system;
		}

		return this;
	}
}