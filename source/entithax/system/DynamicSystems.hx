package entithax.system;

class DynamicSystems implements ISystems
{
	private var initializeSystems: Array<IInitializeSystem>;
	private var executeSystems: Array<IExecuteSystem>;
	private var executeSystemsInfo: Array<ExecuteSystemInfo>;

	public function new()
	{
		initializeSystems = new Array<IInitializeSystem>();
		executeSystems = new Array<IExecuteSystem>();
		executeSystemsInfo = new Array<ExecuteSystemInfo>();
	}

	public function execute(elapsed: Float)
	{
		for(s in executeSystemsInfo)
		{
			if(s.enabled)
			{
				s.system.execute(elapsed);
			}
		}
	}

	public function initialize()
	{
		for(s in initializeSystems)
		{
			s.initialize();
		}
	}

	public function getExecuteSystems(): Array<IExecuteSystem>
	{
		return executeSystems.copy();
	}

	public function setExecuteSystemEnabled(index: Int, enable: Bool)
	{
		executeSystemsInfo[index].enabled = enable;
	}

	public function add(system: ISystem): ISystems
	{
		if(Std.is(system, IExecuteSystem))
		{
			var eSystem: IExecuteSystem = cast system;

			executeSystems.push(eSystem);
			executeSystemsInfo.push({system: eSystem, enabled: true});
		}

		if(Std.is(system, IInitializeSystem))
		{
			initializeSystems.push(cast system);
		}

		return this;
	}
}