package entithax.system;

/// Implement this interface if you want to create a system which should be
/// initialized once in the beginning.
interface IInitializeSystem extends ISystem
{
	public function initialize(): Void;
}
