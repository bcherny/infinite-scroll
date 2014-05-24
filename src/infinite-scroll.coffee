angular
.module 'turn/infiniteScroll', ['infiniteScrollTemplate']
.constant 'infiniteScrollDefaults',

	# how often to poll for changes (ms)
	interval: 100

	# how far from the bottom of the screen the user
	# must be scrolled to trigger the callback (px)
	tolerance: 0

.directive 'infiniteScroll', ($window, infiniteScrollDefaults) ->

	replace: true
	restrict: 'A'
	templateUrl: 'infinite-scroll.html'
	transclude: true

	scope:
		fn: '&infiniteScroll'
		interval: '&infiniteScrollInterval'
		tolerance: '&infiniteScrollTolerance'
		active: '=infiniteScrollActive'

	link: (scope, element, attrs) ->

		# set fn
		if not angular.isFunction scope.fn
			throw new TypeError "infinite-scroll expects scroll function to be defined on scope"
		
		# set default options
		if not angular.isNumber scope.interval
			scope.interval = infiniteScrollDefaults.interval

		if not angular.isNumber scope.tolerance
			scope.tolerance = infiniteScrollDefaults.tolerance 

		angular.extend scope,

			# query interval instance
			timer: null

			# flag for when a load is in progress
			isLoading: false

			# cache window height to prevent unnecessary DOM layouts, this is set by #measure
			windowHeight: 0

			# cache element left/top offset
			elementOffset: do element.offset

			# checks scroll distance, calling fn as needed
			check: ->

				# return early if a load is already in progress
				return false if scope.isLoading

				# load if the user is scrolled to the bottom of the window
				if $window.pageYOffset + scope.windowHeight + scope.tolerance - element[0].scrollHeight - scope.elementOffset.top > 0

					do scope.load

			# load more data
			load: ->

				# prevent any more requests while this one is in progress
				scope.isLoading = true

				# trigger the callback
				(do scope.fn).then scope.done, scope.deactivate

			# resets isLoading flag
			done: ->
				scope.isLoading = false

			# measures window height on resize, for caching purposes
			measure: ->
				scope.windowHeight = $window.innerHeight

			# stop polling
			deactivate: ->
				scope.active = false

			# fired when an element becomes visible or invisible
			setActive: (active) ->

				clearInterval scope.timer

				if active
					scope.timer = setInterval scope.check, scope.interval

		# measure initial window height
		do scope.measure

		# begin polling for scroll events when an element becomes
		# visible, and clear its interval when it becomes invisible
		if angular.isDefined scope.active
			scope.$watch 'active', scope.setActive
		else
			scope.setActive true

		# re-measure window height on window resize
		$window.addEventListener 'resize', scope.measure
		
		# clear intervals and DOM events to prevent memory leaks
		# when the scope or element are torn down
		scope.$on '$destroy', ->
			clearInterval scope.timer
			$window.removeEventListener 'resize', scope.measure