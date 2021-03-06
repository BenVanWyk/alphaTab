package system;

abstract UInt32Array(js.html.Uint32Array) 
{
	public inline function new(length:Int32) this = new js.html.Uint32Array(length.ToHaxeInt());
	
	@:from public static inline function fromArray(a:Array<UInt32>):UInt32Array return cast new js.html.Uint32Array(untyped a);
	@:from public static inline function fromFixedArray(a:FixedArray<UInt32>):UInt32Array return cast new js.html.Uint32Array(untyped a.ToHaxeArray());
	
	public var Length(get, never):Int32;
	public inline function get_Length() : Int32 return this.length;
	
	@:op([]) public inline function get(index:Int32):UInt32 return this[index.ToHaxeInt()];
	@:op([]) public inline function set(index:Int32, val:UInt32):UInt32 return this[index.ToHaxeInt()] = val.ToHaxeFloat();
	
	public inline function iterator() : Iterator<UInt32> return new UInt32ArrayIterator(this);
	
	public inline function ToEnumerable() : system.collections.generic.IEnumerable<UInt32> return new UInt32ArrayEnumerable(this);

	public static inline function empty(size:Int32) return new UInt32Array(size);
}