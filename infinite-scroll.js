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


return ['$window', function ($window) {

	"use strict";

	var options = {


		/**
		 * how often to poll for changes (ms)
		 */
		interval: 50,


		/**
		 * how far from the bottom of the screen the user
		 * must be scrolled to trigger the callback (px)
		 */
		tolerance: 0


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
			 * query interval instance
			 */
				interval,


			/**
			 * flag for when a load is in progress
			 */
				isLoading = false;


			/**
			 * ensure that fn is defined on the $scope
			 */
			if (!$scope[fn]) {
				throw new TypeError('infinite-scroll expects function "' + fn + '" to be defined on $scope');
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

				// only load for downscrolls (ignore upscrolls)
				if ($window.pageYOffset - element[0].scrollHeight + options.tolerance + element[0].offsetHeight > 0) {

					isLoading = true;

					$scope[fn]().then(function() {
						isLoading = false;
					});

					// let angular know this is an async callback
					$scope.$apply();

				}

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
			 * clear intervals and DOM events to prevent memory leaks
			 * when the scope or element are torn down
			 */
			$scope.$on('$destroy', function() {
				clearInterval(interval);
			});
			

		}
		
	};

}];