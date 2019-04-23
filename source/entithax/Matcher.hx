package entithax;

import entithax.Component;
import entithax.Entity;

import de.polygonal.ds.Hashable;

using thx.Arrays;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ExprTools;
#end

class Matcher implements Hashable
{
	public var key(default, null): Int;

	public var indicesAllOf(default, null): ComponentIdArray ;
	public var indicesAnyOf(default, null): ComponentIdArray;
	public var indicesNoneOf(default, null): ComponentIdArray;

	public function new() 
	{
		indicesAllOf = new ComponentIdArray();
		indicesAnyOf = new ComponentIdArray();
		indicesNoneOf = new ComponentIdArray();
	}

	// Create matcher that matches all indices in a list
	inline public static function allOfIndices(indices: ComponentIdArray)
	{
		var matcher = new Matcher();
		matcher.indicesAllOf = indices;
		matcher.calculateHash();

		return matcher;
	}

	inline public static function noneOfIndices(indices: ComponentIdArray)
	{
		var matcher = new Matcher();
		matcher.indicesNoneOf = indices;
		matcher.calculateHash();

		return matcher;
	}

	inline public static function anyOfIndices(indices: ComponentIdArray)
	{
		var matcher = new Matcher();
		matcher.indicesAnyOf = indices;
		matcher.calculateHash();

		return matcher;
	}

	// Convert array of classes to corresponding indices
	public static macro function classesToIndices(indexClasses: Array<ExprOf<Class<Component>>>)
	{
		var ixs = [for (indexClass in indexClasses) {macro $indexClass.id_ ;}];
		return macro $a{ixs};
	}

	public static macro function allOf(indexClasses: Array<ExprOf<Class<Component>>>)
	{
		indexClasses = indexClasses.distinct(function(e1, e2) {
        	return e1.toString() == e2.toString();
    	});

		var indices = macro Matcher.classesToIndices($a{indexClasses});
		
		return macro Matcher.allOfIndices($indices);
	}

	// public macro function setAllOf(indexClasses: Array<ExprOf<Class<Component>>>)
	// {
	// 	indexClasses = indexClasses.distinct(function(e1, e2) {
    //     	return e1.toString() == e2.toString();
    // 	});

	// 	var indices = macro Matcher.classesToIndices($a{indexClasses});
		
	// 	this.indicesAllOf = $indices;
	// 	this.calculateHash();
	// }

	public static macro function noneOf(indexClasses: Array<ExprOf<Class<Component>>>)
	{
		indexClasses = indexClasses.distinct(function(e1, e2) {
        	return e1.toString() == e2.toString();
    	});

		var indices = macro Matcher.classesToIndices($a{indexClasses});
		
		return macro Matcher.noneOfIndices($indices);
	}

	// public macro function setNoneOf(indexClasses: Array<ExprOf<Class<Component>>>)
	// {
	// 	indexClasses = indexClasses.distinct(function(e1, e2) {
    //     	return e1.toString() == e2.toString();
    // 	});

	// 	var indices = macro Matcher.classesToIndices($a{indexClasses});
		
	// 	this.indicesAllOf = $indices;
	// 	this.calculateHash();
	// }

	public static macro function anyOf(indexClasses: Array<ExprOf<Class<Component>>>)
	{
		indexClasses = indexClasses.distinct(function(e1, e2) {
        	return e1.toString() == e2.toString();
    	});

		var indices = macro Matcher.classesToIndices($a{indexClasses});
		
		return macro Matcher.anyOfIndices($indices);
	}

	// public macro function setAnyOf(indexClasses: Array<ExprOf<Class<Component>>>)
	// {
	// 	indexClasses = indexClasses.distinct(function(e1, e2) {
    //     	return e1.toString() == e2.toString();
    // 	});

	// 	var indices = macro Matcher.classesToIndices($a{indexClasses});
		
	// 	this.indicesAnyOf = $indices;
	// 	this.calculateHash();
	// }

	private function calculateHash()
	{
		var hashAllOf = 0;
		var hashAnyOf = 0;
		var hashNoneOf = 0;
		var indexOffset = 500;

		if(indicesAllOf.length > 0)
		{
			for(i in 0...indicesAllOf.length)
				hashAllOf += indicesAllOf[i] + (i * indexOffset);
		}
		
		if(indicesAnyOf.length > 0)
		{
			hashAnyOf = 10000;

			for(i in 0...indicesAnyOf.length)
				hashAnyOf += indicesAnyOf[i] + (i * indexOffset);
		}

		if(indicesNoneOf.length > 0)
		{
			hashNoneOf = 20000;

			for(i in 0...indicesNoneOf.length)
				hashNoneOf += indicesNoneOf[i] + (i * indexOffset);
		}
		key = hashAllOf + hashAnyOf + hashNoneOf;

		// trace("Hash code " + key + " generated for indices: " + indicesAllOf + ', ' + indicesAnyOf + ", " + indicesNoneOf);
	}

	public function matches(entity: Entity): Bool
	{
		var matchesAllOf = indicesAllOf == null || indicesAllOf.length == 0 || entity.hasComponents(indicesAllOf);
		var matchesAnyOf = indicesAnyOf == null ||  indicesAnyOf.length == 0 || entity.hasAnyComponent(indicesAnyOf);
		var matchesNoneOf = indicesNoneOf == null || indicesNoneOf.length == 0 ||  !entity.hasAnyComponent(indicesNoneOf);
		
		return matchesAllOf && matchesAnyOf && matchesNoneOf;
	}

	public function allIndices()
	{
		// TODO: Review this, looking at how Context uses this, probably doesn't work correctly
		// at least for noneOf
		return indicesAllOf.concat(indicesAnyOf).concat(indicesNoneOf).distinct();
	}

	public function equals(m: Matcher): Bool
	{
		return indicesAllOf.equals(m.indicesAllOf) &&
			   indicesAnyOf.equals(m.indicesAnyOf) &&
			   indicesNoneOf.equals(m.indicesNoneOf);
	}
}