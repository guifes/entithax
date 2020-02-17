package entithax.system;

interface ISystems extends IInitializeSystem extends IExecuteSystem
{
	function add(system: ISystem): ISystems;
	function getExecuteSystems(): Array<IExecuteSystem>;
	function setExecuteSystemEnabled(index: Int, enable: Bool): Void;
}
