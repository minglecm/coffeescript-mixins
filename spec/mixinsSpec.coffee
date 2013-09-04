mixins = require '../lib/mixins'

describe "module exports", ->
  it "should export a hash with a boostrap function", ->
    expect(typeof mixins).toEqual 'object'
    expect(typeof mixins.bootstrap).toEqual 'function'

  describe "bootstrapping function", ->
    it "should put an include function on Function.prototype", ->
      expect(Function::include).toBeUndefined()
      mixins.bootstrap()
      expect(Function::include).not.toBeUndefined()

describe "mixin functionality", ->
  classes = null

  defineClasses = ->
    classes = {}

    class classes.FieldMixin
      createFields: jasmine.createSpy('FieldMixin#createFields')

    class classes.ParentWithCreateFields
      createFields: ->
        return 'ParentWithCreateFields#createField'

    class classes.ParentWhoExtends extends classes.ParentWithCreateFields
      createFields: ->
        super

    class classes.ParentWhoExtendsWithoutOverride extends classes.ParentWithCreateFields
    class classes.Parent
    class classes.ClassWithMixin

    class classes.ParentWithOverride extends classes.Parent
      createFields: ->
        super

    class classes.Child extends classes.Parent
      createFields: ->
        super

    class classes.ChildWithMeanParent extends classes.ParentWithOverride

    class classes.FooChild
      createFields: ->
        super

  includeMixin = ->
    classes.ParentWhoExtendsWithoutOverride.include(classes.FieldMixin)
    classes.ParentWhoExtends.include(classes.FieldMixin)
    classes.Parent.include(classes.FieldMixin)
    classes.ClassWithMixin.include(classes.FieldMixin)
    classes.FooChild.include(classes.FieldMixin)

  beforeEach ->
    mixins.bootstrap() # Add include to Function
    classes = null

  describe 'ClassWithMixin', ->
    it 'gets a createFields method', ->
      defineClasses()
      includeMixin()

      view = new classes.ClassWithMixin()
      view.createFields()
      expect(classes.FieldMixin::createFields).toHaveBeenCalled()

  describe 'Child', ->
    it 'supers up to the mixin through the parent', ->
      defineClasses()
      spy = spyOn(classes.Child::, 'createFields').andCallThrough()
      includeMixin()
      view = new classes.Child()

      view.createFields()
      expect(spy).toHaveBeenCalled()
      expect(classes.FieldMixin::createFields).toHaveBeenCalled()

    it 'supers up to the mixin when overriding', ->
      defineClasses()
      spy = spyOn(classes.FooChild::, 'createFields').andCallThrough()
      includeMixin()
      view = new classes.FooChild()

      view.createFields()
      expect(spy).toHaveBeenCalled()
      expect(classes.FieldMixin::createFields).toHaveBeenCalled()

  describe 'ChildWithMeanParent', ->
    it 'works when the parent has a local override', ->
      defineClasses()
      spy = spyOn(classes.ParentWithOverride::, 'createFields').andCallThrough()
      includeMixin()
      view = new classes.ChildWithMeanParent()

      view.createFields()
      expect(spy).toHaveBeenCalled()
      expect(classes.FieldMixin::createFields).toHaveBeenCalled()

  describe 'ParentWithOverride', ->
    it 'calls itself and calls through to super', ->
      defineClasses()
      spy = spyOn(classes.ParentWithOverride::, 'createFields').andCallThrough()
      includeMixin()
      view = new classes.ParentWithOverride()

      view.createFields()
      expect(spy).toHaveBeenCalled()
      expect(classes.FieldMixin::createFields).toHaveBeenCalled()

  describe 'ParentWhoExtends', ->
    it 'calls the mixin not the actual super', ->
      defineClasses()
      spy = spyOn(classes.ParentWithCreateFields::, 'createFields')
      includeMixin()
      view = new classes.ParentWhoExtends()

      view.createFields()
      expect(spy).not.toHaveBeenCalled()
      expect(classes.FieldMixin::createFields).toHaveBeenCalled()

  describe 'ParentWhoExtendsWithoutOverride', ->
    it 'calls the mixin and not the actual super', ->
      defineClasses()
      spy = spyOn(classes.ParentWithCreateFields::, 'createFields')
      includeMixin()
      view = new classes.ParentWhoExtendsWithoutOverride()

      view.createFields()
      expect(spy).not.toHaveBeenCalled()
      expect(classes.FieldMixin::createFields).toHaveBeenCalled()

  describe 'Prototypical Inheritance', ->
    it 'works with mixins', ->
      mixinSpy = jasmine.createSpy('Mixin#foo')
      includeSpy = jasmine.createSpy('Module#include')

      class Mixin
        foo: mixinSpy

      class Module
        include: includeSpy

      class Parent extends Module
        parentFunct: ->

      class Child extends Parent
        @include Mixin

      c = new Child()
    
      # Check mixin functionality
      c.foo()
      expect(mixinSpy).toHaveBeenCalled()

      # Check prototypical inheritance functionality
      c.include()
      expect(includeSpy).toHaveBeenCalled()

      # Check dynamically added functions to an object higher up in the prototype chain
      expect(c.dynamicFunction).toBeUndefined()
      Module::dynamicFunction = dynamicSpy = jasmine.createSpy('Module#dynamicFunction')
      expect(c.dynamicFunction).not.toBeUndefined()

      c.dynamicFunction()
      expect(dynamicSpy).toHaveBeenCalled()

      # Check dynamically replaced functions to an object higher up in the prototype chain
      includeSpy.reset()
      Module::include = newIncludeSpy = jasmine.createSpy('Module#include dynamic replacement')

      c.include()
      expect(newIncludeSpy).toHaveBeenCalled()
      expect(includeSpy).not.toHaveBeenCalled()
