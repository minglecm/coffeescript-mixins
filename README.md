# CoffeeScript Mixins

## Examples

    class Mixin
      sharedMethod: ->
        return 'Hey!'

    class A
      @include Mixin

    class B
      @include Mixin

    a = new A()
    a.sharedMethod() # Hey!

    b = new B()
    b.sharedMethod()