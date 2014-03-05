/**
 * infinite-scroll
 * @dependencies: angularjs
 * @author: Boris Cherny <bcherny@turn.com>
 * @license: Apache2 <http://www.apache.org/licenses/LICENSE-2.0.txt>
 * @usage:
 *
 *  <div infinite-scroll="callbackFn"></div>
 *
 */

module.exports = ['$window', function ($window) {


	'use strict';


	var options = {


		/**
		 * how often to poll for changes (ms)
		 */
		interval: 50,


		/**
		 * how far from the bottom of the screen the user
		 * must be scrolled to trigger the callback (px)
		 */
		tolerance: 100


	};


	return {


		/**
		 * use infinite-scroll as an attribute only
		 */
		restrict: 'A',


		/**
		 * prevent scope rebinding for any child elements
		 */
		scope: false,


		link: function ($scope, element, attrs) {


			var fn = attrs.infiniteScroll,


			/**
			 * cache window height to prevent unnecessary DOM layouts,
			 * this is set by measureWindowHeight()
			 */
				windowHeight = measureWindowHeight(),


			/**
			 * query interval instance
			 */
				interval,


			/**
			 * cache locations at which the callback has already been triggered,
			 * to avoid double-trigerring the callback
			 */
				bucketCache = [],


			/**
			 * flag for when a load is in progress
			 */
				isLoading = false;


			/**
			 * ensure that fn is defined on the $scope
			 */
			if (!$scope[fn]) {
				throw new TypeError('infinite-scroll expects function "', fn, '" to be defined on $scope');
			}


			/**
			 * check for infinite-scroll-interval and infinite-scroll-tolerance attributes
			 */
			if (attrs.infiniteScrollInterval > -1)
				options.interval = attrs.infiniteScrollInterval;

			if (attrs.infiniteScrollTolerance > -1)
				options.tolerance = attrs.infiniteScrollTolerance;


			/**
			 * checks scroll distance, calling fn as needed
			 */
			function check() {

				// return early if a load is already in progress
				if (isLoading) {
					return;
				}

				var scrollY = $window.pageYOffset,
					delta = scrollY + windowHeight - options.tolerance - element.height(),
					bucket = Math.round(scrollY/options.tolerance);

				if (
					// don't load twice for the same scroll position
					bucketCache.indexOf(bucket) < 0 &&

					// only load for downscrolls (ignore upscrolls)
					delta > 0
				) {

					bucketCache.push(bucket);

					isLoading = true;

					$scope[fn]().then(function() {
						isLoading = false;
					});

				}

			}


			/**
			 * measures window height on resize, for caching purposes
			 */
			function measureWindowHeight() {
				return windowHeight = $window.innerHeight;
			}


			/**
			 * fired when an element becomes visible or invisible
			 */
			function visibilityChange (visible) {

				clearInterval(interval);

				if (visible) {
					interval = setInterval(check, options.interval);
				}

			}


			/**
			 * returns true if the element is visible, and false if it is not
			 */
			function getVisibility() {

				return !!element[0].offsetHeight;

			}


			/**
			 * begin polling for scroll events when an element becomes
			 * visible, and clear its interval when it becomes invisible
			 */
			$scope.$watch(getVisibility, visibilityChange);


			/**
			 * re-measure window height on window resize
			 */
			$window.addEventListener('resize', measureWindowHeight);
			

			/**
			 * clear intervals and DOM events to prevent memory leaks
			 * when the scope or element are torn down
			 */
			$scope.$on('$destroy', function() {
				clearInterval(interval);
				$window.removeEventListener('resize', measureWindowHeight);
			});
			

		}
		
	};

}];