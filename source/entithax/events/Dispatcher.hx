package entithax.events;

class Dispatcher<T>
{
    var listeners: Map<String, Array<HandlerOrVoid<T>>>;
    
    public function new()
    {
        listeners = new Map<String, Array<HandlerOrVoid<T>>>();
    }
    
    public function add(name: String, listener: HandlerOrVoid<T>)
    {
        var list: Array<HandlerOrVoid<T>> = null;

        if(listeners.exists(name))
        {
            list = listeners.get(name);
            list.push(listener);
        }
        else 
        {
            list = new Array<T -> Void>();
            list.push(listener);
            listeners.set(name, list);
        }
    }
    
    public function dispatch(name: String, param: T)
    {
        if(listeners.exists(name))
        {
            var list: Array<HandlerOrVoid<T>> = listeners.get(name);

            for(i in 0...list.length)
            {
                list[i](param);
            }
        }
    }
}