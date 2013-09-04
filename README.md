# CoffeeScript Mixins

This function allows you to include other classes (or an object with functions) into a CoffeeScript class.

This allows for better code reuse in classes where inheritance isn't feasible (already extending from one type of Backbone view, etc).

[View Demo](http://jsfiddle.net/zN9kN/1/)

## Usage

You'll need to require and bootstrap the mixins before any of your CoffeeScript class definitions.

	mixins = require 'mixins'
	mixins.bootstrap() # Mixes in include on Function
	
After this initial setup you can utilize the `@include` method in any of your CoffeeScript classes.

## Examples

### Declaring a Mixin

You can create a mixin like any other CoffeeScript class.  Give it some methods, utilize inheritance, or include another mixin.

    # Typical mixin
    class Mixin
      sharedMethod: ->
        return 'Hey!'
          
    # With inheritance
    class CoolMixin extends Mixin
      coolMethod: ->
        return 'Heya!'
        
    # With other mixins
    class MultiMixin
      @include CoolMixin

### Including a mixin

You can include a mixin into a CoffeeScript class using the `include` class method.

    class A
      @include Mixin

    a = new A()
    a.sharedMethod() # Hey!
    
### Overriding Mixed In Functions

You can override mixed in functions and declare your own behavior:

    class Mixin
      sharedMethod: ->
        console.log 'Cool…'
        
    class A
      @include Mixin
      
      sharedMethod: ->
        # please don't console.log in my code.

You can also use `super` to call up to the mixed in function.

	class Mixin
      sharedMethod: ->
        console.log 'Cool...'

    class A
      @include Mixin

      sharedMethod: ->
        console.log 'Really...'
        super
      
    ###
    Outputs:
      Really…
      Cool…
    ###
    a = new A()
    a.sharedMethod() 

### Notes

A mixed in function will take precedence over an inherited function, like so:

    class Mixin
      sharedMethod: ->
        console.log 'Cool...'

    class A
      sharedMethod: ->
        console.log 'Hey...'

    class B extends A
      @include Mixin

    ###
    Outputs:
      Cool...
    ###
    b = new B()
    b.sharedMethod()
  
Calling `super` in an override will not call up to the inherited class but will instead call up to the mixed in class:

    class Mixin
      sharedMethod: ->
        console.log 'Cool...'

    class A
      sharedMethod: ->
        console.log 'Hey...'

    class B extends A
      @include Mixin

      sharedMethod: ->
        super

    ###
    Outputs:
      Cool...
    ###
    b = new B()
    b.sharedMethod()