package entithax.system;

/// Implement this interface if you want to create a system which should be
/// executed every frame.
interface IExecuteSystem extends ISystem
{
	public function execute(elapsed: Float): Void;
}