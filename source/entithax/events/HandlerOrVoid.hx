package entithax.events;

@:callable
abstract HandlerOrVoid<T>(T -> Void) from T -> Void
{
	private function new(cb: T -> Void)
	{
		this = cb;
	}
    
    @:from
	static function fromVoid<T>(cb: Void -> Void): HandlerOrVoid<T>
	{
        return new HandlerOrVoid(function(_) cb());
    }
}