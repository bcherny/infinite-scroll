angular
.module 'turn/infiniteScroll', ['infiniteScrollTemplate']
.constant 'infiniteScrollDefaults',

	# how often to poll for changes (ms)
	interval: 100

	# how far from the bottom of the screen the user
	# must be scrolled to trigger the callback (px)
	tolerance: 100

	# class to add to element when its infinite-scroll
	# instance is disabled
	disabledClassName: 'disabled'

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
		disabledClassName: '&infiniteScrollDisabledClass'
		# container element custimized by user
		containerElement: '&infiniteScrollContainer'
		# the scroll is local if the parent element is used for scrolling
		isLocal: '&infiniteScrollIsLocal'

	link: (scope, element, attrs) ->

		# set fn
		if not angular.isFunction scope.fn
			throw new TypeError "infinite-scroll expects scroll function to be defined on scope"
		
		# set default options
		if not angular.isNumber scope.interval
			scope.interval = infiniteScrollDefaults.interval

		if not angular.isNumber scope.tolerance
			scope.tolerance = infiniteScrollDefaults.tolerance 

		if not angular.isString scope.disabledClassName
			scope.disabledClassName = infiniteScrollDefaults.disabledClassName 

		angular.extend scope,

			# query interval instance
			timer: null

			# flag for when a load is in progress
			isLoading: false

			# cache container height to prevent unnecessary DOM layouts, this is set by #measure
			containerHeight: 0

			# cache element left/top offset
			elementOffsetTop: element[0].offsetTop

			# the container of infinite scroll directive
			container: if (angular.isDefined do scope.containerElement) then (do scope.containerElement)[0]
			else if do scope.isLocal then (do element.parent)[0] 
			else $window

			# checks scroll distance, calling fn as needed
			check: ->

				# return early if a load is already in progress
				return false if scope.isLoading or scope.active is false

				# This is the competitor factor that is calculated to match container's scroll offset
				# This value is got by sum up the container's height and tolerance given by user
				# then subtract the total loaded, scroll-able height, and the offset of container
				containerOffsetCompetitor = scope.containerHeight + scope.tolerance - element[0].scrollHeight - scope.elementOffsetTop

				# load if the user is scrolled to the bottom of the window
				# scrollTop + containerOffsetCompetitor is the result of decision if we need to load more data
				# Note that for customized container, we need to rebate the scope.elementOffsetTop as this value
				# is the total offset on the top
				scrollTop = if (not (angular.isDefined do scope.containerElement) and not do scope.isLocal) then scope.container.pageYOffset
				else scope.container.scrollTop + scope.elementOffsetTop

				do scope.load if (scrollTop + containerOffsetCompetitor > 0)

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
				scope.containerHeight = if (not (angular.isDefined do scope.containerElement) and not do scope.isLocal) then scope.container.innerHeight 
				else scope.container.offsetHeight 

			# stop polling
			deactivate: ->
				scope.isLoading = false
				scope.setActive false

			# fired when an element becomes visible or invisible
			setActive: (active) ->

				clearInterval scope.timer

				if active
					element.removeClass scope.disabledClassName
					scope.timer = setInterval scope.check, scope.interval
				else
					element.addClass scope.disabledClassName

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
