package entithax;

class Dispatcher<T>
{
    var listeners: Map<String, Array<T -> Void>>;
    
    public function new()
    {
        listeners = new Map<String, Array<T -> Void>>();
    }
    
    public function add(name: String, listener: T -> Void)
    {
        var list: Array<T -> Void> = null;

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
            var list: Array<T -> Void> = listeners.get(name);

            for(i in 0...list.length)
            {
                list[i](param);
            }
        }
    }
}