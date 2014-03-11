###
	
	infinite-scroll
	
	@dependencies angularjs
	@author Boris Cherny <bcherny@turn.com>
	@license Apache2 <http://www.apache.org/licenses/LICENSE-2.0.txt>
	@usage <div infinite-scroll="callbackFn"></div>
	
###



return ['$window', ($window) ->


	options =

		# how often to poll for changes (ms)
		interval: 100

		# how far from the bottom of the screen the user
		# must be scrolled to trigger the callback (px)
		tolerance: 100


	infinitescroll = {

		# use infinite-scroll as an attribute only
		restrict: 'A'

		# prevent scope rebinding for any child elements
		scope: false

		link: ($scope, element, attrs) ->


			fn = attrs.infiniteScroll

			# query interval instance
			interval = null

			# flag for when a load is in progress
			isLoading = false

			# cache window height to prevent unnecessary DOM layouts, this is set by measureWindowHeight
			windowHeight = 0

			# checks scroll distance, calling fn as needed
			check = ->

				# return early if a load is already in progress
				if isLoading
					return

				# only load for downscrolls (ignore upscrolls)
				if $window.pageYOffset + windowHeight - options.tolerance - element.height() > 0

					# set this to prevent any mroe requests while this one is in progress
					isLoading = true

					# trigger the callback
					(do $scope[fn]).then ->
						isLoading = false

					# let angular know this is an async callback
					do $scope.$apply

			# measures window height on resize, for caching purposes
			measureWindowHeight = ->
				windowHeight = $window.innerHeight


			# fired when an element becomes visible or invisible
			visibilityChange = (visible) ->

				clearInterval interval

				if visible
					interval = setInterval check, options.interval


			# returns true if the element is visible, and false if it is not
			getVisibility = ->

				not not element[0].offsetHeight


			# ensure that fn is defined on the $scope
			if not $scope[fn]
				throw new TypeError "infinite-scroll expects function '#{fn}' to be defined on $scope"

			# check for infinite-scroll-interval and infinite-scroll-tolerance attributes
			if attrs.infiniteScrollInterval > -1
				options.interval = attrs.infiniteScrollInterval

			if attrs.infiniteScrollTolerance > -1
				options.tolerance = attrs.infiniteScrollTolerance


			# measure initial window height
			do measureWindowHeight


			# begin polling for scroll events when an element becomes
			# visible, and clear its interval when it becomes invisible
			$scope.$watch getVisibility, visibilityChange


			# re-measure window height on window resize
			$window.addEventListener 'resize', measureWindowHeight
			

			# clear intervals and DOM events to prevent memory leaks
			# when the scope or element are torn down
			$scope.$on '$destroy', ->
				clearInterval interval
				$window.removeEventListener 'resize', measureWindowHeight

	}

]