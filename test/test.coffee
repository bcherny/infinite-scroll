describe 'infinite-scroll', ->

	beforeEach module 'turn/infiniteScroll'
	
	beforeEach ->

		inject (@$compile, $rootScope, $controller) =>

			@scope = do $rootScope.$new

			@scope.items = Array.apply null, Array 200
			@scope.scroll = ->
			@scope.isActive = true

			@element = angular.element """
				<div infinite-scroll="scroll()">
					<div ng-repeat="item in items" style="height:100px"></div>
				</div>
			"""

	beforeEach ->

		(@$compile @element) @scope
		do @scope.$apply
		@scope = do @element.scope


	###########################################################################
	

	describe '#check', ->

		it 'should return false if a load is already in progress', ->

			@scope.isLoading = true

			expect do @scope.check
			.toBe false

		it 'should return false if infinite-scroll is inactive', ->

			@scope.active = false

			expect do @scope.check
			.toBe false

		it 'should call #load if the user scrolled to the bottom of the window', inject ($window) ->

			spyOn @scope, 'load'

			@scope.windowHeight = 1
			@scope.tolerance = 0
			@element[0].scrollHeight = 0
			@scope.elementOffset = top: 0

			do @scope.check

			do expect @scope.load
			.toHaveBeenCalled


		it 'should not call #load otherwise', ->

			spyOn @scope, 'load'

			@scope.windowHeight = 0
			@scope.tolerance = 0
			@element[0].scrollHeight = 0
			@scope.elementOffset = top: 0

			do @scope.check

			do expect @scope.load
			.not.toHaveBeenCalled


	describe '#load', ->

		it 'should set scope.isLoading to true', ->

			@scope.isLoading = false
			@scope.fn = -> then: ->

			do @scope.load

			expect @scope.isLoading
			.toBe true

		it 'should call #fn with no arguments', ->

			@scope.fn = -> then: ->

			do spyOn @scope, 'fn'
			.andCallThrough

			do @scope.load

			do expect @scope.fn
			.toHaveBeenCalledWith

		it 'should call #done when #fn is resolved', ->

			spyOn @scope, 'done'

			@scope.fn = -> then: (good) -> do good

			do @scope.load

			do expect @scope.done
			.toHaveBeenCalled

		it 'should call #deactivate when #fn is rejected', ->

			spyOn @scope, 'deactivate'

			@scope.fn = -> then: (good, bad) -> do bad

			do @scope.load

			do expect @scope.deactivate
			.toHaveBeenCalled


	describe '#done', ->

		it 'should set scope.isLoading to false', ->

			console.log @scope

			@scope.isLoading = true

			do @scope.done

			expect @scope.isLoading
			.toBe false


	describe '#measure', ->

		it 'should set scope.windowHeight to the window height', inject ($window) ->

			@scope.windowHeight = 0

			$window.innerHeight = 100

			do @scope.measure

			expect @scope.windowHeight
			.toBe $window.innerHeight


	describe '#deactivate', ->

		it 'should set scope.active to false', ->

			@scope.active = true

			do @scope.deactivate

			expect @scope.active
			.toBe false

		it 'should set scope.isLoading to false', ->

			@scope.isLoading = true

			do @scope.deactivate

			expect @scope.isLoading
			.toBe false


	describe '#setActive', ->

		it 'should clear the timer', ->

			spyOn window, 'clearInterval'

			@scope.timer = 42

			do @scope.setActive

			expect window.clearInterval
			.toHaveBeenCalledWith @scope.timer

		it 'should not set a new timer when passed a falsey argument', ->

			@scope.timer = null

			@scope.setActive false

			expect @scope.timer
			.toBe null

			@scope.setActive undefined

			expect @scope.timer
			.toBe null

			@scope.setActive null

			expect @scope.timer
			.toBe null

		it 'should set a new timer when passed a truthy argument', ->

			do spyOn window, 'setInterval'
			.andCallThrough

			@scope.timer = null
			@scope.check = ->
			@scope.interval = 100

			@scope.setActive 42

			# timer should have been set (setInterval returns a numerical timer ID)
			expect typeof @scope.timer
			.toBe 'number'

			# setInterval should have been called
			expect window.setInterval
			.toHaveBeenCalledWith @scope.check, @scope.interval

		it 'should remove the disabled class if set to active', ->

			@scope.disabledClassName = 'foo'

			@element.addClass @scope.disabledClassName

			expect @element.hasClass @scope.disabledClassName
			.toBe true

			@scope.setActive true

			expect @element.hasClass @scope.disabledClassName
			.toBe false

		it 'should add the disabled class if set to inactive', ->

			@scope.disabledClassName = 'foo'

			@element.removeClass @scope.disabledClassName

			expect @element.hasClass @scope.disabledClassName
			.toBe false

			@scope.setActive false

			expect @element.hasClass @scope.disabledClassName
			.toBe true